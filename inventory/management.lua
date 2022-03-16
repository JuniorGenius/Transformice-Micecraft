stackFindItem = function(self, itemId, canStack)
	for _, item in next, self do
		if item.itemId == itemId then
			if canStack then
				if item.stackable and item.amount < 64 then
					return item
				end
			else
				return item
			end
		end
	end

	return nil
end

inventoryFindItem = function(self, itemId, canStack, onInteraction)
	local stack = (onInteraction and self.interaction or self.slot)
	
	return stackFindItem(stack, itemId, canStack)
end

inventoryCreateItem = function(self, itemId, amount, targetSlot)
	local slot = targetSlot or inventoryFindItem(self, 0)

	if slot then
		return itemCreate(slot, itemId, amount, (amount > 0))
	end
	
	return nil
end

inventoryInsertItem = function(self, itemId, amount, targetSlot, interaction)
	local item = inventoryFindItem(self, itemId, true, false)
	
	if targetSlot then
		if type(targetSlot) == "boolean" then
			item = playerGetInventorySlot(room.player[self.owner], self.selectedSlot)
		elseif type(targetSlot) == "number" then
			item = playerGetInventorySlot(room.player[self.owner], targetSlot)
		elseif type(targetSlot) == "table" then
			item = targetSlot
		end
		
		if item.itemId ~= 0 then
			if (item.stackable and item.amount + amount > 64) or item.itemId ~= itemId then
				item = inventoryFindItem(self, itemId, true, interaction)
			end
		--[[else
			item = inventoryFindItem(self, itemId, true)]]
		end
	end
	
	if item then
		if item.stackable and item.amount + amount <= 64 and item.itemId == itemId then
			itemAdd(item, amount)
			return item
		else
			return inventoryCreateItem(self, itemId, amount, item)
		end
	else
		return inventoryCreateItem(self, itemId, amount, item)
	end
	
	return item
end

inventoryExtractItem = function(self, itemId, amount, targetSlot)
	local item = inventoryFindItem(self, itemId)
	
	if targetSlot then
		if type(targetSlot) == "boolean" then
			item = playerGetInventorySlot(room.player[self.owner], self.selectedSlot)
		elseif type(targetSlot) == "number" then
			item = playerGetInventorySlot(room.player[self.owner], targetSlot)
		elseif type(targetSlot) == "table" then
			item = targetSlot 
		end
	end
	
	if item then
		if item.stackable then
			local fx = item.amount - (amount or 1)
			if fx <= 0 then
				return itemRemove(item, self.owner)
			else
				return itemSubstract(item, amount)
			end
		else
			return itemRemove(item, self.owner)
		end
	end
	
	return item
end

inventoryExchangeItemsPosition = function(item1, item2)
	local exchange = {
		itemId = item1.itemId,
		stackable = item1.stackable,
		amount = item1.amount,
		sprite = item1.sprite
	}
	
	item1.itemId = item2.itemId
	item1.stackable = item2.stackable
	item1.amount = item2.amount
	item1.sprite = item2.sprite
	
	item2.itemId = exchange.itemId
	item2.stackable = exchange.stackable
	item2.amount = exchange.amount
	item2.sprite = exchange.sprite
end