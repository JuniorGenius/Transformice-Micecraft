
blockDestroy = function(self, display, playerObject, dontUpdate)
	if self.type > 0 and self.type <= 256 then
		if self.type == 256 and self.damage ~= math.huge then return end
		self.timestamp = os.time()
		if display then blockHide(self) end
		
		self:onDestroy(playerObject)
		if self.ghost then
			self.type = 0
			self.timestamp = -os.time()
			self.handle = nil
			self.drop = 0
			self.hardness = 0
			
			self.onCreate = dummyFunc
			self.onPlacement = dummyFunc
			self.onDestroy = dummyFunc
			self.onInteract = dummyFunc
			self.onHit = dummyFunc
			self.onDamage = dummyFunc
			self.onContact = dummyFunc
			self.onUpdate =dummyFunc
			self.onAwait = dummyFunc
		else
			--local meta = objectMetadata[self.type]
			self.ghost = true
			self.alpha = 1.0
			self.shadowness = 0.33
			self.damage = 0
			--spreadParticles(meta.particles, 7, "drop", {self.dx+8, self.dx+24}, {self.dy+8, self.dy+24})
			if display then blockDisplay(self) end
		end
		
		if not dontUpdate then
			local blockList = getBlocksAround(self, true)
			for _, block in next, blockList do
				block:onUpdate(playerObject)
			end
			chunkRefreshSegList(map.chunk[self.chunk], blockList)
		end
	end
end

blockCreate = function(self, type, ghost, display, playerObject)
	if type > 0 and type <= 256 then
		self.timestamp = os.time()
		local meta = objectMetadata[type]
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
		
		self.hardness = meta.hardness
		self.drop = meta.drop
		self.durability = meta.durability
		
		self.onInteract = meta.onInteract
		self.onDestroy = meta.onDestroy
		self.onCreate = meta.onCreate
		self.onPlacement = meta.onPlacement
		self.onHit = meta.onHit
		self.onUpdate = meta.onUpdate
		self.onDamage = meta.onDamage
		self.onContact = meta.onContact
		self.onAwait = meta.onAwait
		
		self.isTangible = self.type ~= 0 and (not self.ghost)
		
		self.sprite[1] = {
			meta.sprite or nil,
			mossSprites[--[[map.chunk[chunk].biome]]1] or nil,
			shadowSprite,
			nil,
		}
		
		self:onPlacement(playerObject)
		
		if self.interact then
			if meta.handle then

				self.handle = meta.handle[1](
					table.unpack(meta.handle, 2, #meta.handle)
				)
			end
			map.chunk[self.chunk].interactable[self.id] = self
		else
			self.handle = nil
			map.chunk[self.chunk].interactable[self.id] = nil
		end
		
		if display then
			blockHide(self)
			blockDisplay(self)
		end
		
		if timer >= awaitTime and not self.ghost then
			local blockList = getBlocksAround(self, true)
			for _, block in next, blockList do
				block:onUpdate(playerObject)
			end
			chunkRefreshSegList(map.chunk[self.chunk], blockList)
		end
	end
end

blockDamage = function(self, amount, playerObject)
	if self.type ~= 0 and map.chunk[self.chunk].loaded then
		local meta = objectMetadata[self.type]
		
		self.damage = self.damage + (amount or 2)
		if self.damage > self.durability then self.damage = self.durability end
		self.damagePhase = math.ceil((self.damage*10)/self.durability)
		self.sprite[1][4] = damageSprites[self.damagePhase]
		if self.damage >= meta.durability then
			blockDestroy(self, true, playerObject)
			return true
		else
			if map.chunk[self.chunk].loaded then
				blockHide(self)
				blockDisplay(self)
			end
			
			if self.damage > 0 then 
				appendEvent(5000, blockRepair, self, 1, playerObject)
			end
			
			self:onDamage(playerObject)
		end
	end
	
	return false
end

blockRepair = function(self, amount, playerObject)
	if amount > self.damage then amount = self.damage end
	
	if self.damage > 0 then
		return not blockDamage(self, -amount, playerObject)
	end
	
	return false
end

blockGetInventory = function(self)
	if self.handle then
		return unreference(self.handle)
	end
end

blockInteract = function(self, playerObject)
	if self.interact then
		local distance = distance(self.dx+16, self.dy+16, playerObject.x, playerObject.y)
		if distance < 56 then
			self:onInteract(playerObject)
		else
			playerAlert(playerObject, "You're too far from the "..objectMetadata[self.type].name..".", 328, "N", 14)
		end
	end
end
