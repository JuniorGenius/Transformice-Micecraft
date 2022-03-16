
blockDestroy = function(self, display)
	if self.type ~= 256 then
		if display then blockHide(self) end
		
		if self.ghost then
			self.type = 0
		else
			local meta = blockMetadata[self.type]
			self.ghost = true
			self.alpha = 1.0
			self.shadowness = 0.33
			self.damage = 0
			--spreadParticles(meta.particles, 7, "drop", {self.dx+8, self.dx+24}, {self.dy+8, self.dy+24})
			if display then blockDisplay(self) end
		end
		
		chunkRefreshSegList(map.chunk[self.chunk], getBlocksAround(self, true))
	end
end

blockCreate = function(self, type, ghost, display)
	if type ~= 0 then
		local meta = blockMetadata[type]
		self.type = type
		self.ghost = ghost or false
		self.damage = 0
		self.glow = meta.glow
		self.translucent = meta.translucent
		self.act = (type == 0 or self.ghost) and 0 or -1
		self.mossy = false
		self.alpha = 1.0
		self.shadowness = ghost and 0.33 or 0
		self.interact = meta.interact
		
		self.sprite[1] = {
			meta.sprite or nil,
			mossSprites[--[[map.chunk[chunk].biome]]1] or nil,
			shadowSprite,
			nil,
		}
		
		if self.interact then
			map.chunk[self.chunk].interactable[self.id] = self
		else
			map.chunk[self.chunk].interactable[self.id] = nil
		end
		
		if display then
			blockHide(self)
			blockDisplay(self)
		end
		
		if timer >= awaitTime then
			chunkRefreshSegList(map.chunk[self.chunk], getBlocksAround(self, true))
		end
	end
end

blockDamage = function(self, amount)
	if self.type ~= 0 and map.chunk[self.chunk].loaded then
		local meta = blockMetadata[self.type]
		
		self.damage = self.damage + (amount or 2)
		if self.damage > meta.durability then self.damage = meta.durability end
		self.damagePhase = math.ceil((self.damage*10)/meta.durability)
		self.sprite[1][4] = damageSprites[self.damagePhase]
		
		if self.damage >= meta.durability then
			blockDestroy(self, true)
			return true
		else
			if map.chunk[self.chunk].loaded then
				blockHide(self)
				blockDisplay(self)
			end
		end
	end
	
	return false
end

blockInteract = function(self, player)
	if self.interact then
		local distance = distance(self.dx+16, self.dy+16, player.x, player.y)
		if distance < 48 then
			playerDisplayInventory(player, "craft")
		else
			playerAlert(player, "You're too far from the "..blockMetadata[self.type].name..".", 328, "N", 14)
		end
	end
end