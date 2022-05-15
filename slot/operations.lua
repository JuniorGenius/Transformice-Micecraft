
slotAdd = function(self, amount)
	if self.itemId ~= 0 then
		if self.stackable then
			local fixedAmount = self.amount + amount
			self.amount = fixedAmount > 64 and 64 or fixedAmount
			return fixedAmount > 64 and fixedAmount - 64 or amount
		end
	end
	
	return false
end

slotSubstract = function(self, amount)
	if self.itemId ~= 0 then
		if self.stackable then
			local fixedAmount = self.amount - amount
			self.amount = fixedAmount < 0 and 0 or fixedAmount
			return fixedAmount < 0 and 0 or amount 
		end
	end
end

slotDisplaceAll = function(self, direction, source, target)	
	local newSlot
	if direction.itemId == 0 then
		stackExchangeItemsPosition(self, direction)
		newSlot = direction
	else
		if direction.itemId == self.itemId then
			if direction.amount + self.amount <= 64 then
				slotAdd(direction, self.amount)
				slotEmpty(self, source.name)
				newSlot = direction
			else			
				local _amount = 64 - direction.amount
				slotAdd(direction, _amount)
				if _amount >= self.amount then
					slotEmpty(self, source.name)
					newSlot = direction
				else
					slotSubstract(self, _amount)
					newSlot = self
				end
			end
		else
			if not self.allowInsert then
				local item = stackInsertItem(
					target.inventory[self.stack],
					self.itemId, self.amount, direction
				)
				if item then direction = item end
			else
				stackExchangeItemsPosition(self, direction)
				newSlot = direction
			end
		end
	end
	
	return newSlot or direction
end

slotDisplaceAmount = function(self, direction, amount, source, target)
	local newSlot
	if (self.itemId == direction.itemId or direction.itemId == 0) and self.stackable then
		if self.amount > amount then
			stackExtractItem(
				source.inventory[self.stack], 
				self.itemId, amount, true
			)
			
			stackInsertItem(
				target.inventory.bag,
				self.itemId, amount, direction
			)
			newSlot = self
		else
			if direction.itemId == 0 then
				stackExchangeItemsPosition(self, direction)
				newSlot = direction
			elseif direction.itemId == self.itemId then
				if direction.amount + amount <= 64 then
					slotAdd(direction, amount)
					slotEmpty(self, source.name)
					
					newSlot = direction
				else
					amount = 64 - direction.amount
					slotAdd(direction, amount)
					if direction.amount + amount <= 64 then
						if amount >= self.amount then
							slotEmpty(self, source.name)
							newSlot = direction
						else
							slotSubstract(self, amount)
							newSlot = self
						end
					else
						newSlot = direction
					end
				end
			else
				newSlot = direction
			end
		end
	end	
	
	return newSlot 
end

slotItemMove = function(self, direction, amount, playerName)
	local target, source
	
	if type(playerName) == "table" then
		target = room.player[ playerName[2] ]
		source = room.player[ playerName[1] ]
	else
		target = room.player[playerName]
		source = target
	end 
	
	local newSlot = source.inventory.selectedSlot
	local stack = newSlot.stack
	
	if self and direction then
		local moveCondition
		if target.name ~= source.name then
			moveCondition = (direction.stack ~= "craft")
		else
			moveCondition = (self.id ~= direction.id)
		end
		
		if moveCondition then
			newSlot = (target ~= source and self or direction)
			if direction.allowInsert then
				if amount == 0 then
					newSlot = slotDisplaceAll(self, direction, source, target)
				else
					newSlot = slotDisplaceAmount(self, direction, amount, source, target)
				end
			end
		end
	end
	
	return self, direction, (newSlot or source.inventory.selectedSlot)
end