playerStatic = function(self, activate)
	local playerName = self.name
	if activate then
		tfm.exec.setPlayerGravityScale(playerName, 0)
		tfm.exec.freezePlayer(playerName, true, false)
		_movePlayer(playerName, 0, 0, true, -self.vx, -self.vy, false)
		self.static = os.time() + 4000
	else
		tfm.exec.freezePlayer(playerName, false, false)
		tfm.exec.setPlayerGravityScale(playerName, 1.0)
		self.static = nil
	end
end

playerCorrectPosition = function(self)
	if self.x >= 0 and self.x <= 32640 and self.y > 200 then
		if self.lastActiveChunk ~= self.currentChunk and timer > awaitTime then
			return
			--[[local displacement = ((self.lastActiveChunk-1)%85)
			local side = displacement - ((self.currentChunk-1)%85)
			if side ~= 0 then
				local xpos = (displacement * 12) + (side < 0 and 12 or 1)
				local ypos = 256 - map.heightMaps[1][xpos]
				self.x = xpos * 32
				self.y = (ypos * 32) + 200
				_movePlayer(self.name, self.x, self.y, false, 0, -8)
			end]]
		else
			local isTangible = function(block) return (block.type ~= 0 and not block.ghost) end
			local _getPosBlock = getPosBlock
			if isTangible(_getPosBlock(self.x, self.y-200)) then
				local nxj, nyj, pxj, offset
				local xpos, ypos = self.x+0, self.y-200

				local i = 1
				
				while i < 256 do
					offset = i*32
					nxj = _getPosBlock(self.x-offset, self.y-200)
					nyj = _getPosBlock(self.x, self.y-offset-200)
					pxj = _getPosBlock(self.x+offset, self.y-200)
					if not isTangible(nyj) then
						self.y = self.y-offset
						break
					elseif not isTangible(nxj) then 
						self.x = self.x-offset
						break
					elseif not isTangible(pxj) then
						self.x = self.x+offset
						break
					end
					i = i + 1
				end
				
				if i >= 256 then
					blockDestroy(_getPosBlock(xpos, ypos), self.name)
					self.x = xpos
					self.y = ypos + 200
					i = 0
				end
				
				if i < 256 then
					_movePlayer(self.name, self.x, self.y, false, 0, -8)
				end
			end
		end
	end
end 

playerActualizeHoldingItem = function(self)
	if self.inventory.barActive then
		local select = self.inventory.selectedSlot
		if select.itemId ~= 0 then
			if self.inventory.holdingSprite then tfm.exec.removeImage(self.inventory.holdingSprite) end
			self.inventory.holdingSprite = tfm.exec.addImage(objectMetadata[select.itemId].sprite, "$"..self.name, self.facingRight and 10 or -10, -4, nil, self.facingRight and 0.5 or -0.5, 0.5, 0, 1.0, 0, 0)
		else
			if self.inventory.holdingSprite then
				tfm.exec.removeImage(self.inventory.holdingSprite)
				self.inventory.holdingSprite = nil
			end
		end
	end
end

playerUpdatePosition = function(self, x, y, vx, vy, tfmp)
	if timer >= awaitTime then
		self.x = x or tfmp.x
		self.y = y or tfmp.y
	elseif timer < awaitTime then
		self.x = map.spawnPoint.x
		self.y = map.spawnPoint.y
		_movePlayer(self.name, self.x, self.y)
	end
	
	self.tx = (self.x/32) - 510
	self.ty = 256 - ((self.y-200)/32)
	
	self.vx = vx or tfmp.vx
	self.vy = vy or tfmp.vy
end

playerActualizeInfo = function(self, x, y, vx, vy, facingRight, isAlive)
	local tfmp = tfm.get.room.playerList[self.name]
	
	playerUpdatePosition(self, x, y, vx, vy, tfmp)
	
	if facingRight ~= nil then
		self.facingRight = facingRight
		playerActualizeHoldingItem(self)
	end
	
	self.isAlive = isAlive or (tfmp.isDead and false or true)
	
	if self.isAlive then
		playerCorrectPosition(self)
		
		local realCurrentChunk = getPosChunk(self.x, self.y-200) or getPosChunk(map.spawnPoint.x, map.spawnPoint.y-200)
		if realCurrentChunk ~= self.currentChunk then
			self.lastChunk = self.currentChunk
		end
		
		self.currentChunk = realCurrentChunk
		if map.chunk[realCurrentChunk].activated then
			self.lastActiveChunk = realCurrentChunk
			if self.static and not modulo.timeout then
				playerStatic(self, false)
			end
			
			if not map.chunk[realCurrentChunk].userHandle[self.name] then
				map.handle[realCurrentChunk] = {
					realCurrentChunk, chunkFlush
				}
			end
		else
			if not self.static then
				playerStatic(self, true)
			end
		end
		
		if timer >= awaitTime and self.showDebug then
		local leftstr = string.format(
			"<b>Micecraft</b>\nTicks: 549 ms\n\n<b>Chunks</b>\nLoaded: %d\nActivated: %d\n\nGlobal Grounds: %d/%d\n\n<b>Gravity Forces:</b>\nWind: %d\nGravity: %d\n\n<b>Player - %s</b>\nTFM XY: %d / %d\nMC XY: %d / %d\nfacing: (%s)\nCurrent Chunk: %d (%s)\nLast Chunk: %d",
			map.chunksLoaded,
			map.chunksActivated,
			globalGrounds,
			groundsLimit,
			map.windForce,
			map.gravityForce,
			self.name,
			self.x,	self.y,
			self.tx, self.ty,
			(self.facingRight and "&gt;" or "&lt;"),
			self.currentChunk, (map.chunk[self.currentChunk] and (map.chunk[self.currentChunk].activated and "+" or "-") or "NaN"),
			self.lastChunk
		)
		local rightstr = string.format(
			"Clock Time:\n%d s\n\n<b>Update Status</b>\nLuaAPI: %s\nRevision: %s\n\nTfm: %s\nRevision: %s\n\nLastest: %s\n\nStress: %d/%d ms\n(%d ms)\n\nActive Events: %d",
			timer/1000,
			tostring(tfm.get.misc.apiVersion),
			modulo.apiVersion,
			tostring(tfm.get.misc.transformiceVersion),
			modulo.tfmVersion,
			modulo.lastest,
			modulo.runtimeLapse, modulo.runtimeLimit,
			modulo.runtimeMax,
			#actionsHandle
		)
		local text = "<p align='%s'><font face='Consolas' color='#ffffff'>"
		ui.updateTextArea(778, text:format("right") .. rightstr, self.name)
		ui.updateTextArea(777, text:format("left") .. leftstr, self.name)
		end
	end
end

playerReachNearChunks = function(self, range, forced)
	if (os.time() > self.timestamp and timer%2000 == 0) or forced then
		local cl, dcl, clj, dclj
		if self.currentChunk and self.lastChunk then
			for i=-1, 1 do
				cl = self.lastChunk+(85*i)
				dcl = self.currentChunk+(85*i)
				for j=-2, 2 do
					clj = cl+j
					dclj = dcl+j
					
					local crossCondition = globalGrounds < 512 and (j==0 or i==0) or (--[[j==0 and ]]i==0)
					
					if forced then
						if dclj >= 1 and dclj <= 680 then
							map.handle[dclj] = {dclj, crossCondition and chunkFlush or chunkReload}
						end
					else
						if clj >= 1 and clj <= 680 then
							if not map.handle[clj] then map.handle[clj] = {clj, chunkUnload} end
						end
						
						if dclj >= 1 and dclj <= 680 then
							if (map.handle[dclj] and (map.handle[dclj][2] == chunkLoad or map.handle[dclj][2] == chunkUnload)) or not map.handle[dclj] then
								map.handle[dclj] = {dclj, crossCondition and chunkUpdate or chunkLoad}
							end
						end
					end
				end
			end
			
			self.timestamp = os.time() + 2000
		end
	end
end

playerLoopUpdate = function(self)
	if self.isAlive then
		playerActualizeInfo(self)
			
		if modulo.loading then
			playerReachNearChunks(self)
			
			if map.chunk[self.currentChunk].activated then
				awaitTime = -1000
			else
				if timer >= awaitTime - 1000 then
					awaitTime = awaitTime + 500
				end
			end
		else
			if os.time() > self.timestamp then
				playerReachNearChunks(self)
			end
		end
	
		if self.static and os.time() > self.static then
			playerStatic(self, false)
		end
	end
	
	playerCleanAlert(self)
end