itemAdd = function(self, amount)
	if self.itemId ~= 0 then
		if self.stackable then
			local fixedAmount = self.amount + amount
			self.amount = fixedAmount > 64 and 64 or fixedAmount
			return fixedAmount > 64 and fixedAmount - 64 or amount
		end
	end
	
	return false
end

itemSubstract = function(self, amount)
	if self.itemId ~= 0 then
		if self.stackable then
			local fixedAmount = self.amount - amount
			self.amount = fixedAmount < 0 and 0 or fixedAmount
			return fixedAmount < 0 and 0 or amount 
		end
	end
end

itemMove = function(self, direction, amount, playerName)
	local targetPlayer = playerName
	local sourcePlayer = playerName
	
	if type(playerName) == "table" then
		targetPlayer = playerName[2]
		sourcePlayer = playerName[1]
	end
	
	local newSlot = room.player[sourcePlayer].inventory.selectedSlot
	
	if self and direction then 
		local moveCondition = (targetPlayer ~= sourcePlayer and (direction.id < 100) or (self.id ~= direction.id))
		if moveCondition then
			newSlot = (targetPlayer ~= sourcePlayer and self.id or direction.id)
			if direction.id ~= 110 then
				if amount == 0 then -- Move everything
					if direction.itemId == 0 then
						inventoryExchangeItemsPosition(self, direction)
					else
						if direction.itemId == self.itemId then
							if direction.amount + self.amount <= 64 then
								itemAdd(direction, self.amount)
								itemRemove(self, sourcePlayer)
							else
								itemAdd(direction, self.amount - (64 - (direction.amount + self.amount)))
								newSlot = self.id
							end
						else
							if self.id == 110 then
								local item = inventoryInsertItem(
									room.player[targetPlayer].inventory,
									self.itemId, self.amount, direction, false
								)
								if item then direction = item end
							end
						end
					end
				else -- Move x amount
					if (self.itemId == direction.itemId or direction.itemId == 0) and self.stackable then
						if self.amount > amount then
							inventoryExtractItem(
								room.player[sourcePlayer].inventory, 
								self.itemId, amount, true
							)
							
							inventoryInsertItem(
								room.player[targetPlayer].inventory,
								self.itemId, amount, direction, true
							)
							newSlot = self.id
						else
							if direction.itemId == 0 then
								inventoryExchangeItemsPosition(self, direction)
							elseif direction.itemId == self.itemId then
								if direction.amount < 64 then
									itemAdd(direction, amount)
									itemRemove(self, sourcePlayer)
								end
							end
						end
					end		
				end
			end
		end
	end
	
	return self, direction, newSlot
end