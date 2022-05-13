stackFindItem = function(self, itemId, canStack)
	for _, item in next, self.slot do
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

stackCreateItem = function(self, itemId, amount, targetSlot)
	local slot = targetSlot or stackFindItem(self, 0)

	if slot then
		return itemCreate(slot, itemId, amount, (amount > 0))
	end
	
	return nil
end

stackInsertItem = function(self, itemId, amount, targetSlot)
	local item = stackFindItem(self, itemId, true)
	
	if targetSlot ~= nil then
		if type(targetSlot) == "boolean" then
			if targetSlot then
				item = room.player[self.owner].inventory.selectedSlot
			end
		elseif type(targetSlot) == "number" then
			if targetSlot <= #self.slot then
				item = self.slot[targetSlot]
			end
		elseif type(targetSlot) == "table" then
			item = targetSlot
		end
		
		if item then
			if item.itemId ~= 0 then
				if (item.stackable and item.amount + amount > 64) or item.itemId ~= itemId then
					item = stackFindItem(self, itemId, true)
				end
			end
		else
			return nil
		end
	end
	
	if item then
		if item.stackable and item.amount + amount <= 64 and item.itemId == itemId then
			itemAdd(item, amount)
			return item
		else
			return stackCreateItem(self, itemId, amount, item)
		end
	else
		return stackCreateItem(self, itemId, amount, item)
	end

	return item
end

stackExtractItem = function(self, itemId, amount, targetSlot)
	local item = stackFindItem(self, itemId)
	local own = room.player[self.owner]
	
	if targetSlot ~= nil then
		if type(targetSlot) == "boolean" then
			if targetSlot then
				item = own.inventory.selectedSlot
			end
		elseif type(targetSlot) == "number" then
			item = own.inventory[own.inventory.selectedSlot.stack].slot[targetSlot]
		elseif type(targetSlot) == "table" then
			item = targetSlot 
		end
	end
	
	if item then
		if item.stackable then
			local fx = item.amount - (amount or 1)
			if fx < 1 then
				return itemRemove(item, self.owner)
			else
				itemSubstract(item, amount)
				return item
			end
		else
			return itemRemove(item, self.owner)
		end
	end
	
	
	return item
end

stackFetchCraft = function(self, limit)
	local lookup
	local k = 1
	local m = 0
	local itemList = {}
	
	local _table_insert = table.insert
	
	for i=1, limit do
		m = i
		
		if limit == 4 and i == 3 then
			k = k + 1
		end
		
		if lookup then
			k = k + 1
			if self.slot[m].itemId == craftsData[lookup][1][k] then
				_table_insert(itemList, self.slot[m])
				if k == #craftsData[lookup][1] then
					return craftsData[lookup][2], itemList
				end
			else
				if k <= #craftsData[lookup][1] then
					lookup = nil
					k = 0
					break
				else
					return craftsData[lookup][2], itemList
				end
			end
		else
			for j, craft in next, craftsData do
				if self.slot[m].itemId == craft[1][1] then
					lookup = j
					k = 1
					_table_insert(itemList, self.slot[m])
					
					if #craftsData[lookup][1] == 1 then
						return craftsData[lookup][2], itemList
					else
						break
					end
				end
			end
		end
	end
end


stackExchangeItemsPosition = function(item1, item2)
	local exchange = {
		itemId = item1.itemId,
		stackable = item1.stackable,
		amount = item1.amount,
		sprite = item1.sprite--, stack = item1.stack
	}
	
	item1.itemId = item2.itemId
	item1.stackable = item2.stackable
	item1.amount = item2.amount
	item1.sprite = item2.sprite
	--item1.stack = item2.stack
	
	item2.itemId = exchange.itemId
	item2.stackable = exchange.stackable
	item2.amount = exchange.amount
	item2.sprite = exchange.sprite
	--item2.stack = exchange.stack
end