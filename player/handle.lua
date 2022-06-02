function _Player:static(activate)
	local playerName = self.name
	if activate then
		tfm.exec.setPlayerGravityScale(playerName, 0)
		tfm.exec.freezePlayer(playerName, true, false)
		_movePlayer(playerName, 0, 0, true, -self.vx, -self.vy, false)
		self.staticState = os.time() + 4000
	else
		tfm.exec.freezePlayer(playerName, false, false)
		tfm.exec.setPlayerGravityScale(playerName, 1.0)
		self.staticState = nil
	end
end

function _Player:correctPosition()
	if withinRange(self.x, self.y) then
		if self.lastActiveChunk ~= self.currentChunk and timer > awaitTime then
			return
			--[[return
			local displacement = ((self.lastActiveChunk-1)%chunkRows)
			local side = displacement - ((self.currentChunk-1)%chunkRows)
			if side ~= 0 then
				local xpos = (displacement * chunkRows) + (side < 0 and chunkRows or 1)
				local ypos = 256 - map.heightMaps[1][xpos]
				self.x = xpos * blockSize
				self.y = (ypos * blockSize) + worldVerticalOffset
				_movePlayer(self.name, self.x, self.y, false, 0, -self.vy)
			end]]
		else
			local isTangible = function(block) return (block.type ~= 0 and not block.ghost) end
			local _getPosBlock = getPosBlock
			local yoff = worldVerticalOffset
			if isTangible(_getPosBlock(self.x, self.y-yoff)) then
				local nxj, nyj, pxj, offset

				local xpos, ypos = self.x+0, self.y-yoff

				local i = 1
				
				while i < 256 do
					offset = i * blockSize
					nxj = _getPosBlock(self.x-offset, self.y-yoff)
					nyj = _getPosBlock(self.x, self.y-offset-yoff)
					pxj = _getPosBlock(self.x+offset, self.y-yoff)
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
					self.y = ypos + yoff
					i = 0
				end
				
				if i < 256 then
					_movePlayer(self.name, self.x, self.y, false, 0, -8)
				end
			end
		end
	end
end 

function _Player:actualizeHoldingItem()
	if self.inventory.barActive then
		local select = self.inventory.selectedSlot
		if select.itemId ~= 0 then
			local scale = select.itemId < 512 and 0.5 or 0.85
			local xoffset = 5 / scale -- 10 / 5.8823
			local yoffset = -((scale*4)^2)
			if self.inventory.holdingSprite then tfm.exec.removeImage(self.inventory.holdingSprite) end
			self.inventory.holdingSprite = tfm.exec.addImage(
				objectMetadata[select.itemId].sprite,
				"$"..self.name,
				self.facingRight and xoffset or -xoffset, yoffset,
				nil,
				self.facingRight and scale or -scale, scale,
				0, 1.0,
				0, 0
			)
		else
			if self.inventory.holdingSprite then
				tfm.exec.removeImage(self.inventory.holdingSprite)
				self.inventory.holdingSprite = nil
			end
		end
	end
end

function _Player:updatePosition(x, y, vx, vy, tfmp)
	if timer >= awaitTime then
		self.x = x or tfmp.x
		self.y = y or tfmp.y
	elseif timer < awaitTime then
		self.x = map.spawnPoint.x
		self.y = map.spawnPoint.y
		_movePlayer(self.name, self.x, self.y)
	end
	
	self.tx = (self.x/blockSize) - (worldWidth / 2)
	self.ty = worldHeight - ((self.y-worldVerticalOffset)/blockSize)
	
	self.vx = vx or tfmp.vx
	self.vy = vy or tfmp.vy
end

function _Player:actualizeInfo(x, y, vx, vy, facingRight, isAlive)
	local tfmp = tfm.get.room.playerList[self.name]
	
	self:updatePosition(x, y, vx, vy, tfmp)
	
	if facingRight ~= nil then
		self.facingRight = facingRight
		self:actualizeHoldingItem()
	end
	
	self.isAlive = isAlive or (tfmp.isDead and false or true)
	
	if self.isAlive then
		self:correctPosition()
		local yoff = worldVerticalOffset
		
		local realCurrentChunk = getPosChunk(self.x, self.y-yoff) or getPosChunk(map.spawnPoint.x, map.spawnPoint.y-yoff)
		if realCurrentChunk ~= self.currentChunk then
			self.lastChunk = self.currentChunk
		end
		
		self.currentChunk = realCurrentChunk
		local Chunk = map.chunk[realCurrentChunk]
		if Chunk and Chunk.activated then
			self.lastActiveChunk = realCurrentChunk
			if self.staticState and not modulo.timeout then
				self:static(false)
			end
			
			if not Chunk.userHandle[self.name] then
				map.handle[realCurrentChunk] = {
					realCurrentChunk, "flush"
				}
			end
		else
			if not self.staticState then
				self:static(true)
			end
		end
		
		if timer >= awaitTime and self.showDebug then
		local leftstr = string.format(
			translate("debug left", self.language, {module=modulo.name}),
			map.chunksLoaded,
			map.chunksActivated,
			globalGrounds,
			groundsLimit,
			map.windForce,
			map.gravityForce,
			self.name,
			self.language,
			self.x,	self.y,
			self.tx, self.ty,
			(self.facingRight and "&gt;" or "&lt;"),
			self.currentChunk, (map.chunk[self.currentChunk] and (map.chunk[self.currentChunk].activated and "+" or "-") or "NaN"),
			self.lastChunk
		)
		local rightstr = string.format(
			translate("debug right", self.language),
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

function _Player:reachNearChunks(range, forced)
	if (os.time() > self.timestamp and timer%2000 == 0) or forced then
		range = range or 1
		local cl, dcl, clj, dclj, Chunk, crossCondition
		local chunkList = map.chunk
		local chunks = #chunkList
		if self.currentChunk and self.lastChunk then
			for y=-range, range do
				cl = self.lastChunk + (chunkRows * y)
				dcl = self.currentChunk + (chunkRows * y)
				for x=-range, range do
					clj = cl + x
					dclj = dcl + x
					
					Chunk = chunkList[dclj]
					
					crossCondition = globalGrounds < (groundsLimit * 0.75) and (x==0 or y==0) or (--[[x==0 and ]]y==0)
					
					if (Chunk and not Chunk.userHandle[self.name]) or forced then
						local func = "flush"
						if not Chunk.activated then
							if not crossCondition then
								func = "reload"
							end
						end
						
						if dclj >= 1 and dclj <= chunks then
							map.handle[dclj] = {dclj, func}
						end
					else
						if clj >= 1 and clj <= chunks then
							if not map.handle[clj] then
								map.handle[clj] = {
									clj,
									"unload"
								}
							end
						end
						
						if dclj >= 1 and dclj <= chunks then
							if (map.handle[dclj] and (map.handle[dclj][2] == "load" or map.handle[dclj][2] == "unload")) or not map.handle[dclj] then
								map.handle[dclj] = {
									dclj,
									crossCondition and "update" or "load"
								}
							end
						end
					end
				end
			end
			
			self.timestamp = os.time() + 2000
		end
	end
end

function _Player:loopUpdate()
	if self.isAlive then
		self:actualizeInfo()
			
		if modulo.loading then
			self:reachNearChunks()
			
			if map.chunk[self.currentChunk].activated then
				awaitTime = -1000
			else
				if timer >= awaitTime - 1000 then
					awaitTime = awaitTime + 500
				end
			end
		else
			if os.time() > self.timestamp then
				self:reachNearChunks()
			end
		end
	
		if self.staticState and os.time() > self.staticState then
			self:static(false)
		end
	end
	
	self:cleanAlert()
end