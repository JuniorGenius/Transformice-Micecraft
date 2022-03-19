playerPlaceObject = function(self, x, y, ghost)
	if (x >= 0 and x < 32640) and (y >= 200 and y < 8392) then
		local item = self.inventory.slot[self.inventory.selectedSlot]
		
		if item.itemId <= 256 and item.amount >= 1 then
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
						blockCreate(block, item.itemId, ghost, true)
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
					local drop = objectMetadata[block.type].drop
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

playerHudInteraction = function(self)
	if self.inventory.interaction.crafting then
		
		local lookup = nil
		local k = 1
		local m = i
		local itemsList = {}
		local _table_insert = table.insert
		
		for i=1, self.inventory.interaction.crafting do
			m = i
			if self.inventory.interaction.crafting == 4 and i == 3 then
				k = k + 1
			end
			
			if lookup then
				k = k + 1
				if self.inventory.interaction[m].itemId == craftsData[lookup][1][k] then
					_table_insert(itemsList, self.inventory.interaction[m])
					if k == #craftsData[lookup][1] then
						return itemCreate(self.inventory.interaction[10], craftsData[lookup][2][1], craftsData[lookup][2][2], true), itemsList
					end
				else
					if k <= #craftsData[lookup][1] then
						lookup = nil
						k = 0
						break
					else
						return itemCreate(self.inventory.interaction[10], craftsData[lookup][2][1], craftsData[lookup][2][2], true), itemsList
					end
				end
			else
				for j, craft in next, craftsData do
					if self.inventory.interaction[m].itemId == craft[1][1] then
						lookup = j
						k = 1
						_table_insert(itemsList, self.inventory.interaction[m])
						if #craftsData[lookup][1] == 1 and i == 9 then
							return itemCreate(self.inventory.interaction[10], craftsData[lookup][2][1], craftsData[lookup][2][2], true), itemsList
						else
							break
						end
					end
				end
				

			end
		end
	elseif self.inventory.interaction.furnacing then
		return nil
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