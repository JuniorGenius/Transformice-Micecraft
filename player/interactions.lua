playerPlaceObject = function(self, x, y, ghost)
	if (x >= 0 and x < 32640) and (y >= 200 and y < 8392) then
		local item = self.inventory.selectedSlot
		if not item then return end
		
		if item.itemId <= 256 and item.amount >= 1 then
			local _getPosBlock = getPosBlock
			local block = _getPosBlock(x, y-200)
			
			if block.type == 0 then
				local ldis = 80
				
				local dist = distance(self.x, self.y, block.dx+16, block.dy+16)
				if dist < ldis then
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
						blockCreate(block, item.itemId, ghost, true)
						local item = playerInventoryExtract(self, item.itemId, 1, true, self.inventory.selectedSlot)
						if item then
							tfm.exec.setPlayerScore(self.name, -1, true)
							playerActualizeHoldingItem(self)
							if item.stack == "invbar" then
								itemRefresh(item, self.name, 0, 0)
							end
						end
						--playerUpdateInventoryBar(self)
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
			local dist = distance(self.x, self.y, block.dx+16, block.dy+16)
			
			if dist < ldis then
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
					local drop = objectMetadata[block.type].drop
					local destroyed = blockDamage(block, 10)
					if destroyed then
						if drop ~= 0 and block.type == 0 then
							local item = playerInventoryInsert(self, drop, 1, "invbar", true)
							if item then
								tfm.exec.setPlayerScore(self.name, 1, true)
								playerActualizeHoldingItem(self)
								if item.stack == "invbar" then
									itemRefresh(item, self.name, 0, 0)
								end
							end
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
			playerAlert(self, objectMetadata[block.type].name, 328, "D", 14)
		end
	end
end