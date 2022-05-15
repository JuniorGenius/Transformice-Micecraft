--[[playerGetInventorySlot = function(self, id)
	if id then
		if id < 100 then
			if id >= 1 and id <= 36 then
				return self.inventory.bag.slot[id]
			end
		else
			if id >= 101 and id <= 105 then
				return self.inventory.craft.slot[id-100]
			end
		end
	end
	
	return nil
end]]

playerChangeSlot = function(self, stack, slot, display)
	local onBar = self.inventory.barActive
	local _stack
	
	if type(stack) == "string" or not stack then
		_stack = self.inventory[(stack or "invbar")]
	else
		_stack = stack
	end
	
	local dx, dy
	
	if type(slot) == "number" then
		if slot >= 1 and slot <= #_stack.slot then
			slot = _stack.slot[slot]
		end
	else
		if type(slot) ~= "table" then
			slot = nil
		end
	end
	
	if not slot then
		slot = _stack.slot[1]
	end
	
	self.inventory.selectedSlot = slot
	dx, dy = slot.dx, slot.dy + ((self.inventory.barActive or slot.stack ~= "invbar") and 0 or -34)
	
	if self.inventory.slotSprite then
		tfm.exec.removeImage(self.inventory.slotSprite)
	end
	
	if display then
		if dx and dy then
			local scale = slot.size / 32
			self.inventory.slotSprite = tfm.exec.addImage(
				"17e4653605e.png", "~10",
				dx-3, dy-3,
				self.name,
				scale, scale,
				0.0, 1.0,
				0.0, 0.0
			)
		end
		
		if slot.itemId ~= 0 then	
			playerAlert(self, objectMetadata[slot.itemId].name, 328 + (self.inventory.barActive and 0 or 32), "D", 14)
		else
			eventTextAreaCallback(1001, self.name, "clear")
		end
	end
	playerActualizeHoldingItem(self)
end

playerDisplayInventory = function(self, list)
	local _inv = self.inventory
	
	self.inventory.barActive = false
	self.inventory.displaying = true
	
	if self.onWindow then
		uiRemoveWindow(self.onWindow, self.name)
	end
	
	local width = 332
	local height = 316
	ui.addTextArea(888, "", self.name, 400-(width/2), 210-(height/2), width, height, 0xD1D1D1, 0x010101, 1.0, true)
	
	stackHide(self.inventory.invbar)
	
	local stack, xo, yo, stdisp
	for _, obj in next, list do
		stack, xo, yo, stdisp = table.unpack(obj)
		stack = self.inventory[stack]
		if stack.owner ~= self.name then
			stack.owner = self.name
		end
		stackDisplay(stack, xo, yo, stdisp)
		if stack.identifier == "bag" then
			playerChangeSlot(self, _inv.selectedSlot.stack, _inv.selectedSlot, true)
		end
	end

end

playerDisplayInventoryBar = function(self)
	self.inventory.barActive = true
	playerHideInventory(self)
	
	stackDisplay(self.inventory.invbar, 0, 0, true)
	
	local _inv = self.inventory
	local slot = _inv.selectedSlot
	if type(slot) == "table" then
		playerChangeSlot(self, "invbar", ((slot.id-1)%9) + 1, true)
	end
end

playerUpdateInventoryBar = function(self)
	local _inv = self.inventory
	local yoff = _inv.barActive and 0 or -36
	stackRefresh(_inv.invbar, 0, yoff, _inv.barActive)
	playerChangeSlot(self, "invbar", ((_inv.selectedSlot.id-1)%9) + 1, true)
end

playerHideInventory = function(self)
	self.inventory.displaying = false
	local _slotEmpty = slotEmpty
	
	local Inventory = self.inventory
	
	stackHide(Inventory.bag)
	stackHide(Inventory.invbar)
	stackHide(Inventory.craft)
	stackHide(Inventory.armor)
	stackHide(Inventory.bridge)
	
	playerChangeSlot(self, "invbar", Inventory.selectedSlot, false)
	
	ui.removeTextArea(888, self.name)
	
	local element
	
	local stack = self.inventory.craft
	if stack.output then
		for key, element in next, stack.slot do
			if key < stack.output then
				playerInventoryInsert(self, element.itemId, element.amount, "bag", false)
			end
			_slotEmpty(element)
		end
	end
	
	self.displaying = false
end

playerGetStack = function(self, targetStack, targetSlot)
	local stack
	
	if type(targetStack) == "table" then
		stack = targetStack.identifier
	elseif type(targetStack) == "string" then
		stack = targetStack
	else
		if targetStack == true then
			stack = self.inventory.selectedSlot.stack
		else
			if type(targetSlot) == "table" then
				stack = targetSlot.stack
			elseif targetSlot == true then
				stack = self.inventory.selectedSlot.stack
			end
		end
	end
	
	return stack
end

playerInventoryInsert = function(self, itemId, amount, targetStack, targetSlot)
	local _inv = self.inventory

	local stack, slot = playerGetStack(self, targetStack, targetSlot)

	local success = stackInsertItem(_inv[stack], itemId, amount, targetSlot)
	if not success then
		return stackInsertItem(_inv.bag, itemId, amount, targetSlot)
	end

	return success
end

playerInventoryExtract = function(self, itemId, amount, targetStack, targetSlot)
	local _inv = self.inventory
	local stack, slot = playerGetStack(self, targetStack, targetSlot)

	if _inv[stack] then
		return stackExtractItem(_inv[stack], itemId, amount, targetSlot or _inv.selectedSlot)
	end
end

playerMoveItem = function(self, origin, select, display)
	local destinatary, pass
	local newSlot = select
	
	local onBar = self.inventory.barActive
	
	if select.allowInsert then
		if self.trade.isActive then
			destinatary = room.player[self.trade.whom]
			pass = {self.name, self.trade.whom}
			select = destinatary.inventory.bag.slot[1]
		else
			destinatary = self
			pass = self.name
		end
		
		do -- Movement
			if self.keys[17] then
				origin, select, newSlot = slotItemMove(origin, select, 0, pass)
			elseif self.keys[16] then
				local amount = (origin.id == 0 and 0 or 1)
				origin, select, newSlot = slotItemMove(origin, select, amount, pass)
			end
		end
		
		if display then
			if select then
				local onBar = destinatary.inventory.barActive
				local onInv = select.stack == "invbar"
				if (onInv and onBar) or not onBar then
					slotRefresh(select, destinatary.name, 0,
						onInv and (onBar and 0 or -36) or 0
					)
				end
			end
			
			if origin then
				local onBar = self.inventory.barActive
				local onInv = origin.stack == "invbar"
				if (onInv and onBar) or not onBar then
					slotRefresh(origin, self.name, 0,
						onInv and (onBar and 0 or -36) or 0
					)
				end
			end
		end
	end
	
	return select, newSlot
end

playerHudInteract = function(self, select)
	local origin = self.inventory.selectedSlot
	
	local destinity = self.inventory[select.stack]
	local source = self.inventory[origin.stack]
	
	local output = source.slot[source.output]
	
	local result, ores, sres
	--[[if output and origin.id == output.id then
		ores = origin:callback(self, blockObject)
	else]]
		sres = select:callback(self, blockObject)
	--end
	
	result = sres or ores
	
	printt({origin, select, output}, {"object", "sprite"})
	
	if result then
		if output then
			if origin.id == output.id then
				if select.id ~= origin.id then
					for id, slot in next, source do
						if not slot.output then
							playerInventoryExtract(self,
								slot.itemId, 1,
								source, slot
							)
						end
					end
				else
					slotRefresh(output, self.name, 0, 0)
				end
			else
				slotRefresh(output, self.name, 0, 0)
			end
		else
			slotRefresh(select, self.name, 0, 0)
		end
	else
		if output then
			slotEmpty(output, self.name)
		end
	end
end