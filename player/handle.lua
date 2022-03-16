playerStatic = function(self, activate)
	local playerName = self.name
	if activate then
		tfm.exec.setPlayerGravityScale(playerName, 0)
		tfm.exec.freezePlayer(playerName, true, false)
		tfm.exec.movePlayer(playerName, 0, 0, true, -self.vx, -self.vy, false)
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
				tfm.exec.movePlayer(self.name, self.x, self.y, false, 0, -8)
			end]]
		else
			local isTangible = function(block) return (block.type ~= 0 and not block.ghost) end
			local _getPosBlock = getPosBlock
			if isTangible(_getPosBlock(self.x, self.y-200)) then
				local xpos, ypos, nxj, nyj, pxj, offset

				for i=1, 256 do
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
				end
				tfm.exec.movePlayer(self.name, self.x, self.y, false, 0, -8)
			end
		end
	end
end 

playerActualizeInfo = function(self, x, y, vx, vy, facingRight, isAlive)
	local tfmp = tfm.get.room.playerList[self.name]
	if timer >= awaitTime then
		self.x = x or tfmp.x
		self.y = y or tfmp.y
	end
	if timer < awaitTime or tfmp.y < 0 then
		self.x = map.spawnPoint.x
		self.y = map.spawnPoint.y
		tfm.exec.movePlayer(self.name, self.x, self.y)
	end
	
	self.tx = (self.x/32) - 510
	self.ty = 256 - (self.y/32)
	
	self.vx = vx or tfmp.vx
	self.vy = vy or tfmp.vy
	self.facingRight = facingRight or tfmp.facingRight
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
      if self.static and not modulo.timeout then playerStatic(self, false) end
		else
			playerStatic(self)
		end
		
		if timer >= awaitTime then
		
		ui.updateTextArea(777,
			string.format(
				"<font size='18' face='Consolas'><CH2>%s</CH2></font>\n<D><font size='13' face='Consolas'><b>Pos:</b> x %d, y %d\n<b>Last Chunk:</b> %d\n<b>Current Chunk:</b> %d (%s)\n<b>Global Grounds:</b> %d",
				self.name,
				self.tx, self.ty,
				self.lastChunk,
				self.currentChunk,
				(self.currentChunk >= 1 and self.currentChunk <= 680) and (map.chunk[self.currentChunk].activated and "+" or "-") or "NaN",
				globalGrounds
			), 
			self.name
		)
		
		end
	end
end

playerReachNearChunks = function(self, range, forced)
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
		
		self.timestamp = os.time()
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
			if os.time > self.timestamp + 2000 then
				playerReachNearChunks(self)
			end
		end
	
		if self.static and _os_time() > self.static then
			playerStatic(self, false)
		end
	end
	
	playerCleanAlert(self)
end