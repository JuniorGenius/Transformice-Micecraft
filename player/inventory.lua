playerUpdateInventoryBar = function(self)
	local _itemDisplay = itemDisplay
	for i=1, 9 do
		_itemDisplay(self.inventory.slot[27+i], self.name, true)
	end
end

playerGetInventorySlot = function(self, id)
	if id then
		if id < 100 then
			if id >= 1 and id <= 36 then
				return self.inventory.slot[id]
			end
		else
			if id >= 101 and id <= 110 then
				return self.inventory.interaction[id-100]
			end
		end
	end
	
	return nil
end

playerChangeSlot = function(self, slot)
	local onBar = self.inventory.barActive	
	local dx, dy
	
	if not slot or not ((slot >= 1 and slot <= 36) or (slot > 100 and slot <= 110)) then slot = 1 end
	self.inventory.selectedSlot = slot
	
	local select = playerGetInventorySlot(self, slot)
	dx, dy = itemReturnDisplayPositions(select, self.name)
	
	if self.inventory.slotSprite then tfm.exec.removeImage(self.inventory.slotSprite) end
	if dx and dy then
		local scale = (slot == 110 and (self.inventory.interaction.crafting == 9 and 1.5 or 1.0) or 1.0)
		self.inventory.slotSprite = tfm.exec.addImage(
			"17e4653605e.png", ":10",
			dx-9, (dy-12)+((onBar and slot ~= 110) and 34 or 0),
			self.name,
			scale, scale,
			0.0, 1.0,
			0.0, 0.0
		)
	end
	
	if select.itemId ~= 0 then	
		playerAlert(self, blockMetadata[select.itemId].name, 328 + (self.inventory.barActive and 0 or 32), "D", 14)
	else
		eventTextAreaCallback(1001, self.name, "clear")
	end
end

inventorySlotsDisplay = function(self, limit)
	local _itemDisplay = itemDisplay
	for i=1, 36 do
		_itemDisplay(self.slot[i], self.owner)
		if i <= limit or i == 10 then
			_itemDisplay(self.interaction[i], self.owner)
		end
	end
end

playerDisplayInventory = function(self, type)
	local identifier, lim
	self.inventory.barActive = false
	
	self.inventory.displaying = true
	
	if type == "inventory" then
		self.inventory.interaction.crafting = 4
		identifier = "17eb175a263.png"
	elseif type == "craft" then
		self.inventory.interaction.crafting = 9
		identifier = "17eb1755684.png"
	elseif type == "furnace" then
		self.inventory.interaction.furnacing = true
		identifier = "17eb175ee63.png"
	end
	
	lim = self.inventory.interaction.crafting or 2
		
	if self.inventory.sprite then tfm.exec.removeImage(self.inventory.sprite) end
	
	self.inventory.sprite = tfm.exec.addImage(
		identifier, ":1",
		234, 42,
		self.name,
		1.0, 1.0,
		0.0, 1.0,
		0.0, 0.0
	)
	playerChangeSlot(self, self.inventory.selectedSlot)
	
	inventorySlotsDisplay(self.inventory, lim)
end

playerDisplayInventoryBar = function(self)
	self.inventory.barActive = true
	
	if self.inventory.sprite then tfm.exec.removeImage(self.inventory.sprite) end
	
	self.inventory.sprite = tfm.exec.addImage(
		"17e464e9c5d.png", ":1",
		245, 350,
		self.name,
		1.0, 1.0,
		0.0, 0.85,
		0.0, 0.0
	)
	
	if self.inventory.selectedSlot <= 27 then
		playerChangeSlot(self, 27 + ((self.inventory.selectedSlot-1)%9)+1)
	elseif self.inventory.selectedSlot > 100 then
		playerChangeSlot(self, 28)
	else
		playerChangeSlot(self, self.inventory.selectedSlot)
	end
	playerUpdateInventoryBar(self)
end

playerHideInventory = function(self)
	self.inventory.interaction.crafting = false
	self.inventory.interaction.furnacing = false
	self.inventory.displaying = false
	local item
	local _itemHide, _itemRemove, _inventoryInsertItem = itemHide, itemRemove, inventoryInsertItem
	
	for i=1, 36 do
		_itemHide(self.inventory.slot[i], self.name)
		if i <= 10 then
			item = self.inventory.interaction[i]
			_itemHide(item, self.name)
			if i ~= 10 then _inventoryInsertItem(self.inventory, item.itemId, item.amount, false, false) end
			_itemRemove(self.inventory.interaction[i], self.name)
		end
	end
	
	playerDisplayInventoryBar(self)
end