function _Player:changeSlot(stack, slot, display)
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
			self:alertMessage(objectMetadata[slot.itemId].name, 328 + (self.inventory.barActive and 0 or 32), "D", 14)
		else
			eventTextAreaCallback(1001, self.name, "clear")
		end
	end
	self:actualizeHoldingItem()
end

function _Player:displayInventory(list)
	local _inv = self.inventory
	
	self.inventory.barActive = false
	self.inventory.displaying = true
	
	if self.onWindow then
		uiRemoveWindow(self.onWindow, self.name)
	end
	
	local width = 332
	local height = 316
	ui.addTextArea(888, "", self.name, 400-(width/2), 210-(height/2), width, height, 0xD1D1D1, 0x010101, 1.0, true)
	
	self.inventory.invbar:hide()
	
	local stack, xo, yo, stdisp
	for _, obj in next, list do
		stack, xo, yo, stdisp = table.unpack(obj)
		stack = self.inventory[stack]
		if stack.owner ~= self.name then
			stack.owner = self.name
		end
		
		stack:display(xo, yo, stdisp)
		if stack.identifier == "bag" then
			self:changeSlot(_inv.selectedSlot.stack, _inv.selectedSlot, true)
		end
	end

end

function _Player:displayInventoryBar()
	self.inventory.barActive = true
	self:hideInventory()
	
	self.inventory.invbar:display(0, 0, true)
	
	local _inv = self.inventory
	local slot = _inv.selectedSlot
	if type(slot) == "table" then
		self:changeSlot("invbar", ((slot.id-1)%9) + 1, true)
	end
end

function _Player:updateInventoryBar()
	local _inv = self.inventory
	local yoff = _inv.barActive and 0 or -36
	_inv.invbar:refresh(0, yoff, _inv.barActive)
	self:changeSlot("invbar", ((_inv.selectedSlot.id-1)%9) + 1, true)
end

function _Player:hideInventory(list)
	list = list or {"bag", "invbar", "craft", "armor", "bridge"}
	local Inventory = self.inventory
	
	self.inventory.displaying = false

	for _, target in next, list do
		if Inventory[target] then
			Inventory[target]:hide()
		end
	end
	
	self:changeSlot("invbar", Inventory.selectedSlot, false)
	
	ui.removeTextArea(888, self.name)
	
	local element
	
	local stack = self.inventory.craft
	if stack.output then
		for key, Element in next, stack.slot do
			if key < stack.output then
				self:inventoryInsert(Element.itemId, Element.amount, "bag", false)
			end
			Element:empty()
		end
	end
	
	self.displaying = false
end

function _Player:getStack(targetStack, targetSlot)
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

function _Player:inventoryInsert(itemId, amount, targetStack, targetSlot)
	local _inv = self.inventory

	local stack, slot = self:getStack(targetStack, targetSlot)

	local success = _inv[stack]:insertItem(itemId, amount, targetSlot)
	if not success then
		return _inv.bag:insertItem(itemId, amount, targetSlot)
	end

	return success
end

function _Player:inventoryExtract(itemId, amount, targetStack, targetSlot)
	local _inv = self.inventory
	local stack, slot = self:getStack(targetStack, targetSlot)

	if _inv[stack] then
		return _inv[stack]:extractItem(itemId, amount, targetSlot or _inv.selectedSlot)
	end
end

function _Player:moveItem(origin, select, display)
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
				origin, select, newSlot = origin:itemMove(select, 0, pass)
			elseif self.keys[16] then
				local amount = (origin.id == 0 and 0 or 1)
				origin, select, newSlot = origin:itemMove(select, amount, pass)
			end
		end
		
		if display then
			if select then
				local onBar = destinatary.inventory.barActive
				local onInv = select.stack == "invbar"
				if (onInv and onBar) or not onBar then
					select:refresh(destinatary.name, 0,
						onInv and (onBar and 0 or -36) or 0
					)
				end
			end
			
			if origin then
				local onBar = self.inventory.barActive
				local onInv = origin.stack == "invbar"
				if (onInv and onBar) or not onBar then
					origin:refresh(self.name, 0,
						onInv and (onBar and 0 or -36) or 0
					)
				end
			end
		end
	end
	
	return select, newSlot
end

function _Player:fetchCraft(Slot)
	if not Slot then return end
	
	local Stack = self.inventory[Slot.stack]
	local retval
	if Stack then
		local result = Stack:fetchCraft()
		local TargetSlot = Stack.slot[#Stack.slot]
		
		if result then
			retval = TargetSlot:fill(result[1], result[2], true)
		else
			retval = TargetSlot:empty(self.name)
		end
		
		TargetSlot:refresh(self.name)
	end
	
	return retval
end

function _Player:hudInteract(select)
	local origin = self.inventory.selectedSlot
	
	local destinity = self.inventory[select.stack]
	local source = self.inventory[origin.stack]
	
	local output = source.slot[source.output]
	
	local result, ores, sres
	if output and origin.id == output.id then
		local subject = self.inventory[origin.stack].slot[1]
		
		if subject then
			ores = subject:callback(self, blockObject)
		end
	else
		sres = select:callback(self, blockObject)
	end
	
	result = sres or ores
	
	if result then
		if output then
			if origin.id == output.id then
				if select.id ~= origin.id then
					for id, slot in next, source.slot do
						if id < #source.slot then
							self:inventoryExtract(
								slot.itemId, 1,
								source, slot
							)
							
							slot:refresh(self.name, 0, 0)
						else
							self:hudInteract(output)
						end
					end
				else
					output:refresh(self.name, 0, 0)
				end
			else
				output:refresh(self.name, 0, 0)
			end
		else
			select:refresh(self.name, 0, 0)
		end
	else
		local clean = function(Slot)
			Slot:empty(self.name)
			Slot:refresh(self.name, 0, 0)
		end
		
		if output then
			clean(output)
		else
			output = destinity.slot[destinity.output]
			if output then
				clean(output)
			end
		end
	end
end