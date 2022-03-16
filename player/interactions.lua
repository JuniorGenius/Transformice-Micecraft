playerPlaceBlock = function(self, x, y)
	if (x >= 0 and x < 32640) and (y >= 200 and y < 8392) then
		local item = self.inventory.slot[self.inventory.selectedSlot]
		
		if item.stackable and item.amount >= 1 then
			local _getPosBlock = getPosBlock
			local block = _getPosBlock(x, y-200)
			
			if block.type == 0 then
				local ldis = 80
				local xdis = math.abs(self.x-(block.dx+16))
				local ydis = math.abs(self.y-(block.dy+16))
				if xdis < ldis and ydis < ldis then
					local blocksAround = {_getPosBlock(x-32, y-200), _getPosBlock(x, y-232), _getPosBlock(x+32, y-200), _getPosBlock(x, y-168)}
					local around, areAround	= false, 4
					for i=1, 4 do
						if blocksAround[i].type ~= 0 then
							around = true
							break
						elseif blocksAround[i].type == 0 then
							areAround = areAround - 1
							if i==4 then around = false end
						end
					end
					
					if around then
						blockCreate(block, item.itemId, false, true)
						if inventoryExtractItem(self.inventory, item.itemId, 1, true) then tfm.exec.setPlayerScore(self.name, -1, true) end
						playerUpdateInventoryBar(self)
						--recalculateShadows(block, 9*(areAround/4))
					end
				end
			end
		end
	end
end

playerDestroyBlock = function(self, x, y)
	if (x >= 0 and x < 32640) and (y >= 200 and y < 8392) then
		local _getPosBlock = getPosBlock
		local block = _getPosBlock(x, y-200)
		if block.type ~= 0 then
			local ldis = 80
			local xdis = math.abs(self.x-(block.dx+16))
			local ydis = math.abs(self.y-(block.dy+16))
			if xdis < ldis and ydis < ldis then
				local blocksAround = {_getPosBlock(x-32, y-200), _getPosBlock(x, y-232), _getPosBlock(x+32, y-200), _getPosBlock(x, y-168)}
				local notAround, around = 4, false
				for i=1, 4 do
					if blocksAround[i].type == 0 or blocksAround[i].ghost then
						around = false
						break
					elseif blocksAround[i].type ~= 0 or blocksAround[i].ghost then
						notAround = notAround + 1
						if i == 4 then around = true end
					end
				end
				
				if not around then
					local drop = blockMetadata[block.type].drop
					local destroyed = blockDamage(block, 10)
					if destroyed then
						if drop ~= 0 and block.type == 0 then
							if inventoryInsertItem(self.inventory, drop, 1, true) then tfm.exec.setPlayerScore(self.name, 1, true) end
							playerUpdateInventoryBar(self)
						end
						--recalculateShadows(block, 9*(notAround/4))
					end
				end
			end
		end
	end
end

playerInitTrade = function(self, whom, activate)
	if whom and self ~= whom then
		self.trade.whom = whom
		self.trade.timestamp = os.time()
		self.trade.isActive = activate or false
	end
end

playerCancelTrade = function(self)
	self.trade.whom = nil
	self.trade.timestamp = os.time()
	self.trade.isActive = false
end

playerBlockInteract = function(self, block)
	if block.type ~= 0 then
		if block.interact then
			blockInteract(block, self)
		else
			playerAlert(self, blockMetadata[block.type].name, 328, "D", 14)
		end
	end
end