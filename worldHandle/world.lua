worldRefreshChunks = function()
	local chunkList = map.chunk
	for i=1, #chunkList do
		map.handle[i] = {i, "deactivate"}
	end

	for _, Player in next, room.player do
		Player.timestamp = os.time()
	end
end

handleChunksRefreshing = function()
	local _os_time = os.time
	local _pcall = pcall

	local peak = modulo.runtimeLimit
	local counter = modulo.runtimeLapse
	local lapse = 0
	local dif = _os_time()
	
	local lcalls = room.isTribe and 16 or 24
	
	local handle = map.handle
	local chunkList = map.chunk
	
	local calls = 0
	
	local ok, result
	
	local Chunk
	
	local HNDL
	
	
	for i=1, #chunkList do
		if handle[i] then
			if counter < peak and calls < lcalls then
				HNDL = handle[i]
				lapse = _os_time()
				Chunk = chunkList[handle[i][1]]
				ok, result = _pcall(Chunk[handle[i][2]], Chunk)
				if ok then
					if result then
						if handle[i][2] ~= "unload" then
							calls = calls + 1
						else
							calls = calls + 0.5
						end
					end
					
					handle[i] = nil
				else
					if handle[i][2] == "unload" then
						error("Issue on (Chunk:unload):\n\n" .. result)
					else
						handle[i][2] = "unload"
					end
				end
				counter = counter + (_os_time() - lapse)
			else
				print(string.format("<R>Chunk timeout ~ ~ ~</R>\n<D><T>Calls:</T> %f/%d p\n<T>Runtime:</T> %d/%d ms", calls, lcalls, counter, peak))
				map.timestamp = _os_time()
				--counter = peak
				break
			end
		end
	end
	
	if calls ~= 0 then
		map.timestamp = _os_time()
	end
	
	modulo.runtimeLapse = counter
	
	return (_os_time() - dif), calls
end

recalculateShadows = function(origin, range)
	local tt = os.time()
	local self
	local yk, sdn
	local display = {}
	local _distance, _table_insert, _tfm_exec_removeImage, _tfm_exec_addImage, _getPosBlock = distance, table.insert, tfm.exec.removeImage, tfm.exec.addImage, getPosBlock
	
	range = math.ceil(range)
	for i=-range, range do
		yk = origin.dy+((i*blockSize)-1)
		for j=-range, range do
			self = _getPosBlock(origin.dx+((j*blockSize)-1), yk)
			
			if self.type ~= 0 and not self.translucent then
				sdn = (_distance(origin.x, origin.y, self.x, self.y)/8)*0.67
				if sdn > 0.67 then sdn = 0.67 end
				if (sdn < self.shadowness and i <= 0) or (sdn > self.shadowness and i >= 0) then
					self.shadowness = sdn
					_table_insert(display, self)
				end
			end
		end
	end

	for _, self in next, display do
		_tfm_exec_removeImage(self.sprite[2][3])
		self.sprite[2][3] = _tfm_exec_addImage(self.sprite[1][3], "!1", self.dx, self.dy, nil, 1.0, 1.0, 0, self.shadowness*self.alpha, 0, 0)
	end
end


structureCreate = function(id, xOrigin, yOrigin, overwrite)
	local struct = structureData[id]
	local xrow, tile, block
	local xpos, ypos
	local _getPosBlock = getPosBlock
	local type = 2*math.random(2)
	for y in next, struct do
		xrow = struct[y]
		for x in next, xrow do
			tile = xrow[x]
			if tile[1] ~= 0 then
				block = _getPosBlock(
					xOrigin + (tile[3]*blockSize),
					yOrigin - (tile[4]*blockSize)
				)
				
				if block.type == 0 or overwrite then
					blockCreate(block, tile[1]+type, tile[2], false)
				end
			end
		end
	end
end 

getFixedSpawn = function()
	local point, surfp
	for x=0, chunkLines-1 do
		point = (worldChunks - (chunkRows/2)) - (chunkRows*x)
		for y=chunkHeight, 1, -1 do
			surfp = map.chunk[point].block[y][6]
			if surfp.type == 0 --[[or surfp.ghost ]]then
				return {x=16320, y=surfp.dy-100}
			end
		end
	end
	
	return {x=(worldRightEdge/2), y=worldVerticalOffset}
end

generateBoundGrounds = function()
	local gc = 0
	local bodydef = {type=14, width=blockSize, height=3000}
	local xpos, ypos
	
	for i=1, 3 do
		ypos = ((3000*(i-1))+1500)-608
		addPhysicObject(worldSize+(i*2), -16, ypos, bodydef)
		addPhysicObject(worldSize+1+(i*2), worldRightEdge+16, ypos, bodydef)
	end
	
	bodydef = {type=14, width=3000, height=blockSize, friction=0.2}
	for i=4, 11 do
		xpos = ((3000*(i-5))+1500)-180
		addPhysicObject(worldSize+8+i, xpos, worldLowerEdge, bodydef)
	end
end

createNewWorld = function()
	local Chunk_New = _Chunk.new
	local chunkList = map.chunk
	local duo = worldChunks * 2
	
	local loadmsg = translate("loading new world", room.language) .. "..."
	
	modulo.count = 0
	
	local ttt = os.time()
	for i=1, worldChunks do
		chunkList[i] = Chunk_New(i, false, false, 1)
		modulo:updatePercentage(duo, loadmsg)
		
		chunkList[i]:calculateCollisions()
		modulo:updatePercentage(duo, loadmsg)
	end
	print((os.time() - ttt) .. " ms")
	
	map.spawnPoint = getFixedSpawn()
	xmlLoad = xmlLoad:format(
		worldLowerEdge, worldRightEdge,
		map.spawnPoint.x, map.spawnPoint.y
	)
	
	_tfm_exec_removeImage(modulo.bar)
	modulo.count = 0

	math.randomseed(os.time())
end

startPlayer = function(playerName, spawnPoint)
	if not room.player[playerName] then
		room.player[playerName] = _Player.new(playerName, spawnPoint)
		local Player = room.player[playerName]
		map.userHandle[playerName] = true
		
		do -- Binding
			local _system_bindKeyboard = system.bindKeyboard
			for k=0, 200 do
				_system_bindKeyboard(playerName, k, false, true)
				_system_bindKeyboard(playerName, k, true, true)
				Player.keys[k] = false
			end
			system.bindMouse(playerName, true)
		end
		
		tfm.exec.setAieMode(true, 2.5, playerName)
		eventPlayerDied(playerName, true)
		
		if timer > 3000 then
			Player:reachNearChunks(1, true)
		end
	end
end

worldExplosion = function(x, y, radius, power, cause)
    power = power or 1
    local range = 2 + math.ceil(radius)
    local distance = distance
    local getPosBlock = getPosBlock
	local blockDamage, blockDestroy = blockDamage, blockDestroy
    local block, force, dist
    local xx, yy
    
    local exp = 7
    y = y - worldVerticalOffset
	
	local destr = range * (3 / 4)
	local ghost = range + (range - destr)
	
	local chunks = {}

	local _table_insert = function(tbl, el)
		if not tbl then tbl = {} end
			
		tbl[#tbl+1] = el
		
		return tbl
	end
    
    for yf=-range, range do
        yy = y + (yf*blockSize)
		
        for xf=-range, range do
            xx = x + (xf*blockSize)
            block = getPosBlock(xx, yy)
            
			if block.type > 0 then
				dist = distance(xx, yy, x, y) / 32
				if dist <= destr then
					blockDestroy(block, true, cause, true)
				end
				
				if dist <= ghost then
					blockDestroy(block, true, cause, true)
					
					if not chunks[block.chunk] then chunks[block.chunk] = {} end
					local n = #chunks[block.chunk]
					chunks[block.chunk][n+1] = block
				else
					force = (radius / dist) * power
					blockDamage(block, math.ceil(force*exp), cause)
				end
			end
        end
		
    end
	
	local chunkList = map.chunk
	for i, blockList in next, chunks do
		if blockList then
			chunkList[i]:refreshSegList(blockList)
		end
	end
	map.timestamp = os.time() 
	
	tfm.exec.explosion(x, y+worldVerticalOffset, 15*power, range*blockSize, false)
	
end

initWorld = function()
	room.rcount = room.rcount + 1
	room.timestamp = os.time()
	
	generateBoundGrounds()
	setWorldGravity(0, room.rcount == 1 and 0 or 10)
	
	tfm.exec.setGameTime(0)
	ui.setMapName(modulo.name)
	
	for playerName, Player in next, room.player do
		eventPlayerRespawn(playerName)
		if not modulo.loading then
			setUserInterface(playerName)
		end
	end
end
