function _Slot:add(amount)
	if self.itemId ~= 0 then
		if self.stackable then
			local fixedAmount = self.amount + amount
			self.amount = fixedAmount > 64 and 64 or fixedAmount
			return fixedAmount > 64 and fixedAmount - 64 or amount
		end
	end
	
	return false
end

function _Slot:substract(amount)
	if self.itemId ~= 0 then
		if self.stackable then
			local fixedAmount = self.amount - amount
			self.amount = fixedAmount < 0 and 0 or fixedAmount
			return fixedAmount < 0 and 0 or amount 
		end
	end
end

function _Slot:displaceAll(direction, source, target)	
	local newSlot
	if direction.itemId == 0 then
		stackExchangeItemsPosition(self, direction)
		newSlot = direction
	else
		if direction.itemId == self.itemId then
			if direction.allowInsert then
				if direction.amount + self.amount <= 64 then
					direction:add(self.amount)
					self:empty(source.name)
					
					newSlot = direction
				else			
					local fx = 64 - direction.amount
					direction:add(fx)
					self:substract(fx)
					
					if not self.allowInsert then
						newSlot = target.inventory[self.stack]:insertItem(
							self.itemId, self.amount, nil
						)
					else
						newSlot = direction
					end
				end
			end			
		else
			if not self.allowInsert then
				local item = target.inventory[self.stack]:insertItem(
					self.itemId, self.amount, nil
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

function _Slot:displaceAmount(direction, amount, source, target)
	local newSlot
	
	local transfer = function(_source, _origin, _target, _direction)
		_target.inventory[_direction.stack]:insertItem(
			_origin.itemId, amount, _direction
		)
		_source.inventory[_origin.stack]:extractItem(
			_origin.itemId, amount, true
		)
	end
	
	if direction.itemId == 0 then
		if self.allowInsert then
			transfer(source, self, target, direction)
			if self.amount > 0 then
				newSlot = self
			end
		else
			stackExchangeItemsPosition(self, direction)
			newSlot = direction
		end
	elseif self.itemId == direction.itemId then
		if direction.allowInsert then
			
			if direction.amount + amount <= 64 then
				direction:add(amount)
				self:empty(source.name)
			
				newSlot = direction
			else
				local fx = 64 - direction.amount
				direction:add(fx)
				
				self:substract(fx)
				
				newSlot = self:displaceAll(direction, source, target)
			end
		else
			newSlot = direction
		end
	else
		if not self.allowInsert then
			self:displaceAll(direction, source, target)
		end
	end
	
	return newSlot 
end

function _Slot:itemMove(direction, amount, playerName)
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
					newSlot = self:displaceAll(direction, source, target)
				else
					newSlot = self:displaceAmount(direction, amount, source, target)
				end
			end
		end
	end
	
	return self, direction, (newSlot or source.inventory.selectedSlot)
end