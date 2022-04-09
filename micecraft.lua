-- Micecraft --
-- Script created by Indexinel#5948

-- ==========	RESOURCES	========== --

local string = string
local table = table

local system = system
local tfm = tfm
local ui = ui

local globalGrounds = 0

local timer = 0
local awaitTime = 3000

local xmlLoad = '<C><P Ca="" H="8392" L="32640" /><Z><S></S><D><DS X="%d" Y="%d" /></D><O /></Z></C>'

local dummyFunc = function() return end

local room = {
	totalPlayers = 0,
	isTribe = (string.sub(tfm.get.room.name, 1, 2) == "*\003"),
	setMode = string.match(tfm.get.room.name, "micecraft%A+([_%a]+)"),
	runtimeMax = 0,
	player = {}
}

local modulo = {
	creator = "Indexinel#5948",
	name = "Micecraft",
	loading = true,
  loadImg = {
    [1] = {"17f94a1608c.png", "17f94a1cb39.png"},
    [2] = {}
  },
	sprite = "17f949fcbb4.png",
	runtimeLapse = 0,
	runtimeMax = 0,
	runtimeLimit = 0,
  timeout = false
}

modulo.runtimeMax = (room.isTribe and 40 or 60)
modulo.runtimeLimit = modulo.runtimeMax - 8

local map = {
	size = {
		height = 256,
		width = 1020
	},
	chunk = {},
	
	type = 0,
	
	background = nil,
	
	seed = 0,
	
	loadingTotalTime = 0,
	loadingAverageTime = 0,
	totalLoads = 0,
	
	spawnPoint = {},
	heightMaps = {},
	handle = {},
	timestamp = 0,
	
	structures = {}
	--[[sun = {
		x = 16320,
		y = 200,---5000,
		glow = 1024--2000
	}]]
}
 
local event = {}
local onEvent, errorHandler
onEvent = function(eventName, callback)
	if not event[eventName] then
		event[eventName] = {}
	end
	table.insert(event[eventName], callback)
	
	event[eventName][0] = function(...)
		for i=1, #event[eventName] do
			local ok, result = pcall(event[eventName][i], ...)
			
			if not ok then
				errorHandler(result, eventName, i)
				return
			end
		end
	end
	
	_G["event" .. eventName] = function(...)
		if event and event[eventName] then return event[eventName][0](...) end
	end
end

errorHandler = function(err, eventName, instance)
	tfm.exec.addImage("17f94a1608c.png", "~42", 0, 0, nil, 1.0, 1.0, 0, 1.0, 0, 0)
	tfm.exec.addImage("17f949fcbb4.png", "~43", 70, 120, nil, 1.0, 1.0, 0, 1.0, 0, 0)
	ui.addTextArea(42069,
		string.format(
			"<p align='center'><font size='18'><R><B><font face='Wingdings'>M</font> Fatal Error</B></R></font>\n\n<CEP>%s</CEP>\n\n<CS>%s</CS>\n\n%s\n\n\n<CH>Send this to Indexinel#5948</CH>",
			err, debug.traceback(),
			(eventName and instance) and ("<D>Event: <V>event" .. eventName .. "</V> #" .. instance .. "</D>") or ""
		),
		nil,
		100, 50,
		600, 300,
		0x010101, 0x010101,
		0.8, true
	)

	for name, evt in next, event do
		if name == "Loop" then
			event["PlayerDied"] = nil
			for _, act in next, evt do
				act = nil
			end
			timer = 0
			evt[1] = function(elapsed, remaining)
				timer = timer + 500
				local lim = 120
				if timer < lim*1000 then
					ui.setMapName(
						("<O>Module will <R>shut down</R> in <D>%d s<"):format(
							math.ceil(lim-(timer/1000))
						)
						
					)
				else
					system.exit()
				end
			end
		else
			evt = nil
		end
	end
	
	tfm.exec.newGame('<C><P /><Z><S><S P=",,,,,,," L="75" H="10" T="14" Y="-150" X="400" /><S L="75" P=",,,,,,," T="14" Y="-185" X="415" H="10" /><S P=",,,,,,," L="75" X="385" T="14" Y="-185" H="10" /><S P=",,,,,,," L="200" H="150" T="14" Y="-175" N="" X="400" /></S><D><DS X="400" Y="-165" /></D><O /></Z></C>')
	tfm.exec.setWorldGravity(0, 0)
	for playerName, playerObject in next, tfm.get.room.playerList do
		tfm.exec.respawnPlayer(playerName)
		tfm.exec.freezePlayer(playerName, true, false)
	end
	
	local _ui_removeTextArea = ui.removeTextArea
	for i=0, 3000 do
		_ui_removeTextArea(i)
	end
	
	eventHandler = function()
		return
	end
end

local actionsCount = 0
local actionsHandle = {}


local 	_math_round,
		_table_extract,
		distance,
		varify,
		toBase,
		linearInterpolation,
		cosineInterpolate,
		generatePerlinHeightMap,
		dump,
		printt,
		getPosChunk,
		getPosBlock,
		getTruePosMatrix,
		spreadParticles,
		getBlocksAround,
		addPhysicObject,
		removePhysicObject,
		appendEvent,
		removeEvent



local 	blockNew,
		blockDestroy,
		blockCreate,
		blockDamage,
		blockRepair,
		blockGetInventory,
		blockInteract



local 	chunkNew,
		chunkCalculateCollisions,
		chunkLoad,
		chunkUnload,
		chunkReload,
		chunkActivateSegment,
		chunkActivateSegRange,
		chunkDeactivateSegment,
		chunkDeleteSegment,
		chunkRefreshSegment,
		chunkRefreshSegList,
		chunkActivate,
		chunkDeactivate,
		chunkDelete,
		chunkRefresh,
		chunkFlush,
		chunkUpdate



local 	playerNew,
		playerAlert,
		playerCleanAlert,
		playerChangeSlot,
		playerDisplayInventory,
		playerDisplayInventoryBar,
		playerUpdateInventoryBar,
		playerHideInventory,
		playerGetStack,
		playerInventoryInsert,
		playerInventoryExtract,
		playerMoveItem,
		playerHudInteract,
		playerHudInteract,
		playerPlaceObject,
		playerDestroyBlock,
		playerInitTrade,
		playerCancelTrade,
		playerBlockInteract,
		playerStatic,
		playerCorrectPosition,
		playerActualizeHoldingItem,
		playerActualizeInfo,
		playerReachNearChunks,
		playerLoopUpdate



local 	itemNew,
		itemCreate,
		itemRemove,
		itemAdd,
		itemSubstract,
		itemDisplaceAll,
		itemDisplaceAmount,
		itemMove,
		itemDisplay,
		itemHide,
		itemRefresh



local 	stackNew,
		stackFill,
		stackEmpty,
		stackFindItem,
		stackCreateItem,
		stackInsertItem,
		stackExtractItem,
		stackFetchCraft,
		stackExchangeItemsPosition,
		stackDisplay,
		stackHide,
		stackRefresh



local 	worldRefreshChunks,
		handleChunksRefreshing,
		recalculateShadows,
		structureCreate,
		getFixedSpawn,
		generateBoundGrounds,
		createNewWorld,
		startPlayer,
		worldExplosion




-- If the data references a function, then put it in ./main/resources
-- If not, put it here. Just make sure to declare the local variable
-- here so its scope is still reachable by the functions that use them.

local structureData = {
	[1] = { -- {type, ghost, xoff, yoff}
		{{0},{72,true,-1,7},{72,false,0,7},{72,true,1,7},{0}},
		{{0},{72,false,-1,6},{72,false,0,6},{72,false,1,6},{0}},
		{{72,false,-2,5},{72,false,-1,5},{72,false,0,5},{72,false,1,5},{72,false,2,5}},
		{{72,false,-2,4},{72,false,-1,4},{72,false,0,4},{72,false,1,4},{72,false,2,4}},
		{{0},{0},{71,false,0,3},{0},{0}},
		{{0},{0},{71,false,0,2},{0},{0}},
		{{0},{0},{71,false,0,1},{0},{0}}
	}
}

local craftsData = {
	--[[
		Structure (for optimization):
		array[1] = Crafting composition
			- sub[n] = block at the n position in the crafting table
		array[2] = Crafting result
			- sub[1] = item recompense
			- sub[2] = amount of the item
	]]
	{{1,1,0,1,1}, {6, 64}},
	{{19,19,19,19,0,19,19,19,19}, {51, 1}},
	{{73}, {70, 4}},
	{{75}, {70, 4}},
	{{70,70,0,70,70}, {50, 1}}
}

local stackPresets
local objectMetadata

local furnaceData = {
	{source, {returns, quantity}},
}

local damageSprites = {"17dd4b6df60.png", "17dd4b72b5d.png", "17dd4b7775d.png", "17dd4b7c35f.png", "17dd4b80f5e.png", "17dd4b85b5f.png", "17dd4b8a75e.png", "17dd4b8f35f.png", "17dd4b93f5e.png", "17dd4b98b5d.png"}

local mossSprites = {"17dd4b9d75e.png", "17dd4bb075d.png", "17dd4ba235f.png", "17dd4babb5c.png", "17dd4ba6f77.png"}

local shadowSprite = "17e2d5113f3.png"

local cmyk = {{"17e13158459.png", 0}, {"17e13161c88.png", 0}, {"17e1316685d.png", 0}, {"17e1315d05f.png", 0}}

-- ==========	UTILITIES	========== --

_math_round = function(number, precision)
	local _mul = 10^precision
	return math.floor(number*_mul) / _mul
end

_table_extract = function(t, e)
	for i, v in next, t do
		if v == e then
			return table.remove(t, i)
		end
	end
end

distance = function(ax, ay, bx, by)
	return math.sqrt((bx-ax)^2 + (by-ay)^2)
end

varify = function(args, pattern)
	local vars = {}
	args:gsub(" ", "")
	for arg in args:gmatch(pattern or "(%d+)?%p") do
		table.insert(vars, arg)
	end
	return table.unpack(vars)
end

toBase = function(n, b)
	n = math.floor(n)
	if not b or b==10 then return tostring(n) end
	local dg = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local t={}
	local sign = n < 0 and "-" or ""
	if sign == "-" then n = -n end
	
	repeat
		local d = (n%b)+1
		n = math.floor(n/b)
		table.insert(t, 1, dg:sub(d, d))
	until n == 0

	return sign .. table.concat(t, "")
end

linearInterpolation = function(r1, g1, b1, r2, g2, b2, sep, e)
	local ar = (r2-b1)/sep
	local ag = (g2-b1)/sep
	local ab = (b2-b1)/sep

	return (ar*e)+r1, (ag*e)+g1, (ab*e)+b1
end

cosineInterpolate = function(a, b, x)
	local f = (1-math.cos(x*math.pi))*0.5
	return (a*(1-f)) + (b*f)
end

generatePerlinHeightMap = function(seed, amplitude, waveLength, surfaceStart, width, heightMid)
	local _math_random = math.random
	local _math_floor = math.floor
	local _cosInt = cosineInterpolate
	if seed then math.randomseed(seed) end
	
	local heightMap = {}
	local amp = amplitude or 30 -- 172
	local wl = waveLength or 24 -- 64
	local x, y = 0, surfaceStart or 128 -- 1, 128
	local hval = heightMid or 128
	local a, b = _math_random(), _math_random()
	
	while x < width do
		if x%wl == 0 then
			a = b
			b = _math_random()
			y = hval + (a*amp)
		else
			y = hval + (_cosInt(a, b, (x%wl)/wl) * amp)
		end
		
		heightMap[x+1] = _math_floor(y+0.5) or 1
		
		x = x + 1
	end

	return heightMap
end

dump = function(var, nest, except)
  local avoid = {}
  
  if except then
    for _, key in next, except do
      avoid[key] = true
    end
  end
  
	nest = nest or 1
	if type(var) == "table" then
		local str = (nest == 1 and tostring(var):gsub("table: ", "") .. " =" or "") .. " {\n"
		for k, v in pairs(var) do
      local retVal = avoid[k] and "exceptionValue" or dump(v, nest+1, except)
			local isNumber = type(k) == "number"
			k = "<CEP>" .. k .. "</CEP>"
			if isNumber then k = "["..k.."]" end
			str = str .. string.rep("\t", nest) .. k .. " = " .. retVal .. ",\n"--( and ",\n" or "\n")
		end
		
		return (str .. string.rep("\t", nest-1) .. '}'):gsub(",\n\t*}", "\n"..string.rep('\t', nest-1).."}")
	else
		local color = 'N'
		local st = var
		local type = type(var)
		if type == "string" then
			st = '"' .. var .. '"'
			color = 'T'
		elseif type == "number" then
			color = 'V'
		elseif type == "boolean" then
			color = var and 'CH' or 'CH2'
		elseif type == "function" then
			color = 'D'
		end
		
		return "<"..color..">".. tostring(st) .."</"..color..">"
	end
end

printt = function(var, except)
	local _, val = pcall(dump, var, 1, except)
	print("<N2>" .. val .. "</N2>")
end

local _math_floor = math.floor
getPosChunk = function(x, y, passObject)
	if x < 0 then x = 0
	elseif x > 32640 then x = 32640 end
	if y < 0 then y = 0
	elseif y > 8192 then y = 8192 end
	local _mf = _math_floor
	
	local yc = 85*_mf((y/32)/32)
	local xc = _mf((x/32)/12)
	local eq = yc + xc + 1
	
	return passObject and map.chunk[eq] or eq
end

getPosBlock = function(x, y)
	if x < 0 then x = 0
	elseif x > 32640 then x = 32640 end
	if y < 0 then y = 0
	elseif y > 8192 then y = 8192 end

	local chunk = getPosChunk(x, y, true)
	return chunk.block[1+(_math_floor(y/32)%32)][1+(_math_floor(x/32)%12)]
end

getTruePosMatrix = function(chunk, x, y)
	local ch = chunk-1
	return ((ch%85)*12)+(x-1), (_math_floor(ch/85)*32)+(y-1)
end

spreadParticles = function(particles, amount, kind, xor, yor)
	local particles = (type(particles) == "number" and {particles} or (particles or 0))
	local ax, bx, ay, by
	if type(xor) == "table" then
		ax = xor[1]
		bx = xor[2]
	else
		ax = xor
		bx = xor
	end
	if type(yor) == "table" then
		ay = yor[1]
		by = yor[2]
	else
		ay = yor
		by = yor
	end
	
	local xs, ys, xa, ya
	local lpar = #particles
	
	local _rand = math.random
	local _displayParticle = tfm.exec.displayParticle
	for j=1, amount do
		if kind == "drop" then
			xs = _rand(-6, 6)/8
			xa = -xs/8
			ys = _rand(-9, -12)/8
			ya = -ys/7.5--13.33
		end
		_displayParticle(
			particles[_rand(#particles)],
			_rand(ax, bx), _rand(ay, by),
			xs, ys,
			xa, ya,
			nil
		)
	end
end

local _table_insert = table.insert

getBlocksAround = function(self, include, cross)
	local condition
	local blockList = {}
	
	local _getPosBlock = getPosBlock
	local xp, yp = self.dx + 16, self.dy - 184
	
	for i=-1, 1 do
		for j=-1, 1 do
			condition = (not cross and (true) or (j==0 or i==0))
			if ((not (i==0 and j==0)) or include) and condition then
				blockList[#blockList+1] = _getPosBlock(xp+(32*j), yp+(32*i))
			end
		end
	end
	
	return blockList
end

local _tfm_exec_addPhysicObject = tfm.exec.addPhysicObject
addPhysicObject = function(id, x, y, bodydef)
	_tfm_exec_addPhysicObject(id, x, y, bodydef)
	globalGrounds = globalGrounds + 1
end

local _tfm_exec_removePhysicObject = tfm.exec.removePhysicObject
removePhysicObject = function(id)
	_tfm_exec_removePhysicObject(id)
	globalGrounds = globalGrounds - 1
end

local _tfm_exec_movePlayer = tfm.exec.movePlayer
local _movePlayer = function(playerName, xPosition, yPosition, positionOffset, xSpeed, ySpeed, speedOffset)
	_tfm_exec_movePlayer(playerName, xPosition, yPosition, positionOffset, xSpeed, ySpeed, speedOffset)
	local self = room.player[playerName]
	if self then
		self.x = (positionOffset and self.x + xPosition or xPosition)
		self.y = (positionOffset and self.y + yPosition or yPosition)
		self.vx = (speedOffset and self.x + xSpeed or xSpeed)
		self.vy = (speedOffset and self.y + ySpeed or ySpeed)
	end
end

appendEvent = function(executionTime, callback, ...)
	local exec = os.time() + executionTime
	
	actionsCount = actionsCount + 1
	actionsHandle[#actionsHandle + 1] = {
		exec, callback, {...}, actionsCount
	}
	
	return actionsCount
end

removeEvent = function(id)
	local pos
	for i, obj in next, actionsHandle do
		if id == obj[4] then
			pos = i
			break
		end
	end
	
	if pos then
		return table.remove(actionsHandle, pos)
	end
end

-- ==========	BLOCK	========== --

blockNew = function(x, y, type, damage, ghost, glow, translucent, mossy, chunk, surfacePoint)
	local xp, yp = getTruePosMatrix(chunk, x, y)
	yp = 256-yp
	
	
	local tang = type ~= 0 and (not ghost)
	local meta = objectMetadata[type]
	
	local id = ((x-1)*32) + y
	local block = {
		x = xp,
		y = yp,
		rx = x,
		ry = y,
		
		id = id,
		gid = ((chunk-1)*384) + id,
		act = tang and -1 or 0,
		chunk = chunk,

		type = type,
		ghost = ghost,
		glow = glow,
		translucent = translucent,
		mossy = mossy,
		
		isTangible = tang,
		
		damage = damage or 0,
		damagePhase = 0,
		durability = meta.durability,
		
		shadowness = (ghost and not translucent) and 0.33 or 0,
		sprite = {},
		alpha = 1.0,
		dx = xp*32,
		dy = ((256-yp)*32)+200,
		
		timestamp = 0,
		event = 0,
		
		interact = meta.interact,
		handle = (meta.handle),
		
		onInteract = meta.onInteract,
		onDestroy = meta.onDestroy,
		onCreate = meta.onCreate,
		onPlacement = meta.onPlacement,
		onHit = meta.onHit,
		onUpdate = meta.onUpdate,
		onDamage = meta.onDamage,
		onContact = meta.onContact,
		onAwait = meta.onAwait
	}
	
	--[[if type ~= 0 then
		local chunkk = map.chunk[chunk]
		block.shadowness = (distance(0, yp, 0, surfacePoint)/8)*0.67--128
		if block.shadowness > 0.67 then block.shadowness = 0.67 end
	end]]
	block.sprite = {
		[1] = {
			block.type ~= 0 and meta.sprite or nil,
			nil, --block.type >= 1 and mossSprites[--[[map.chunk[chunk].biome]]1] or nil,
			shadowSprite,
			nil,
		},
		[2] = {
		}
	}
	
	return block
end
local _tfm_exec_addImage = tfm.exec.addImage
local blockDisplay = function(self)
	if self.type ~= 0 then
		local _addImage = _tfm_exec_addImage
		local sprite = self.sprite[1]
		self.sprite[2] = {
			_addImage(sprite[1], "_1", self.dx, self.dy, nil, 1.0, 1.0, 0, 1.0, 0, 0),
			nil, -- self.mossy and _addImage(sprite[2], "_2", self.dx, self.dy, nil, 1.0, 1.0, 0, 1.0, 0, 0) or nil,
			self.translucent and nil or _addImage(sprite[3], "_3", self.dx, self.dy, nil, 1.0, 1.0, 0, self.shadowness, 0, 0), -- self.shadowness*self.alpha
			self.damage > 0 and _addImage(sprite[4], "_4", self.dx, self.dy, nil, 1.0, 1.0, 0, 1.0, 0, 0) or nil
		}
	end
end

local _tfm_exec_removeImage = tfm.exec.removeImage

local blockHide = function(self)
	if self.type ~= 0 then
		local _removeImage = _tfm_exec_removeImage
		local sprite = self.sprite[2]
		for k=1, 4 do
			if sprite[k] then 
				_removeImage(sprite[k])
				sprite[k] = nil
			end
		end
	end
end

blockDestroy = function(self, display, playerObject, dontUpdate)
	if self.type > 0 and self.type < 256 then
		self.timestamp = os.time()
		if display then blockHide(self) end
		
		self:onDestroy(playerObject)
		if self.ghost then
			self.type = 0
			self.timestamp = -os.time()
			self.handle = nil
			
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
	if type > 0 and type < 256 then
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
			blockDestroy(self, true, playerName)
			return true
		else
			if map.chunk[self.chunk].loaded then
				blockHide(self)
				blockDisplay(self)
			end
			
			if self.damage > 0 then 
				appendEvent(5000, blockRepair, self, 1, Player)
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
		local inv
	
		inv = self.handle
		inv.id = self.gid
		return inv
	end
end

blockInteract = function(self, playerObject)
	if self.interact then
		local distance = distance(self.dx+16, self.dy+16, playerObject.x, playerObject.y)
		if distance < 48 then
			self:onInteract(playerObject)
		else
			playerAlert(playerObject, "You're too far from the "..objectMetadata[self.type].name..".", 328, "N", 14)
		end
	end
end


-- ==========	CHUNK	========== --

chunkNew = function(id, loaded, activated, biome, heightMaps)
	local _math_random, _blockNew = math.random, blockNew

	local xc = ((id-1)%85)*12
	local yc =  256-((math.floor((id-1)/85)*32)-1)

	local self = {
		id = id,
		loaded = false,
		activated = false,
		biome = biome or 1,
		surfacePoint = heightMaps[1][xc+6],
		block = {},
		interactable = {},
		grounds = {
			[1] = {},
			[2] = {},
		},
		segments = {},
		x = 32*xc,
		y = 32*(256-(yc-1))+200,
		ioff = ((id-1)*384),
		timestamp = 0
	}
	
	for i=1, 32 do
		self.block[i] = {}
	end
	
	local ghost, type, yr, xr
	
	local surfacePoint, dirtLevel, stoneLevel, oreLevel
	local checkCaves = function(yp, xp)
		local hm
		for i=2, 7 do
			hm = heightMaps[i][xp]
			if yp <= hm and yp >= hm-3 then return true end
		end
		
		return false
	end
	
	for j=1, 12 do
		xr = xc + j
		surfacePoint = heightMaps[1][xr]
		dirtLevel = surfacePoint-1
		stoneLevel = surfacePoint-7
		oreLevel = surfacePoint-18
		
		for i=1, 32 do
			type = 0
			ghost = false
			yr = yc-i
			
			if yr <= surfacePoint then
				if yr == surfacePoint then
					type = 2
					if yr > 172 then type = 3 end
				elseif (yr <= dirtLevel and yr > stoneLevel) then
					type = 1
				elseif (yr <= stoneLevel and yr ~= 1) then
					type = 10
					if yr <= oreLevel then
						if (_math_random(30) - yr/100 ) <= 2.5 then type = _math_random(11, 16) end
					end
				end
			
				ghost = checkCaves(yr, xr)
			end
			
			if yr <= 1 then
				type = 256
				ghost = false
			end
			
			self.block[i][j] = _blockNew(
				j, -- x
				i, -- y
				type, -- type
				0,  -- damage
				(ghost or type == 0), -- ghost
				false, -- glow 
				false, -- translucent
				false, -- mossy
				id,
				surfacePoint
			)
		end
		
	end
	
	return self
end

chunkCalculateCollisions = function(self)
	local matrix = self.block
    local height = #matrix
    local width = #matrix[1]
	local _table_insert = table.insert
    
    local matches = 0
    local assign
    
    local xstr, ystr
    
    local xend, yend
	
	local segments = {}
    
    local x, y = 1, 1
    
    repeat
        matches = 0

        xend = width
        yend = height
        
		xstr = 1
        ystr = nil
        
        x = 1
        while x <= xend do

            y = ystr or 1
            while y <= yend do
                if matrix[y][x].act == -1 then
                    if not ystr then
                        ystr = y
                        xstr = x
                        
                        assign = ((xstr-1) * height) + ystr
                    else
                        if y == height and x == xstr then
                            yend = y
                        end
                    end
                    
                    matches = matches + 1
                    matrix[y][x].act = assign
                else
                    if ystr then
                        if x == xstr then
                            yend = y - 1
                        else
                            xend = x - 1
                            
                            for i = ystr, y-1 do
                                matrix[i][x].act = -1
								matches = matches - 1
                            end
							
							break
                        end
                    end
                end
                y = y + 1
            end
            x = x + 1
        end
		
		if matches > 0 then
			local _width = 32*((xend - xstr)+1)
			local _height = 32*((yend - ystr)+1)
			
			_table_insert(self.segments, assign)
			_table_insert(segments, assign)
			
			self.grounds[1][assign] = {
				id = self.ioff + assign,
				xPos = self.x + (32*(xstr-1)) + (_width/2),
				yPos = self.y + (32*(ystr-1)) + (_height/2),
				bodydef = {
					type = 14,
					width = _width,
					height = _height,
					friction = 0.3,
					restitution = 0.2
				},
				startPoint = {xstr, ystr},
				endPoint = {xend, yend}
			}
		end
    until (matches <= 0)
	
	return segments
end
chunkLoad = function(self)
	if not self.loaded then
		local _blockDisplay = blockDisplay
		for i=1, 32 do
			for j=1, 12 do
				_blockDisplay(self.block[i][j])
			end
		end
		
		self.loaded = true
		return true
	end
end

chunkUnload = function(self, onlyVisual)
	local _blockHide = blockHide 
	if self.loaded then
		for i=1, 32 do
			for j=1, 12 do
				_blockHide(self.block[i][j])
			end
		end
		if self.activated and not OnlyVisual then chunkDeactivate(self) end
		self.loaded = false
		return true
	end
	
	return false
end

chunkReload = function(self)
	chunkUnload(self, true)
	chunkLoad(self)
	
	return true
end
chunkActivateSegment = function(self, seg)
	local obj = self.grounds[1][seg]
	if obj then
		addPhysicObject(obj.id, obj.xPos, obj.yPos, obj.bodydef)
		self.grounds[2][seg] = obj.id
	end
end

chunkActivateSegRange = function(self, segList)
	local _chunkActivateSegment = chunkActivateSegment
	for _, seg in next, segList do
		_chunkActivateSegment(self, seg)
	end
end

chunkDeactivateSegment = function(self, seg)
	if seg > 0 then
		if self.grounds[2][seg] then
			removePhysicObject(self.grounds[2][seg])
		end
		self.grounds[2][seg] = nil
	end
end

chunkDeleteSegment = function(self, seg)
	if seg > 0 then
		if self.grounds[1][seg] then
			local block
			local limits = self.grounds[1][seg]
			_table_extract(self.segments, seg)
			for y=limits.startPoint[2], limits.endPoint[2] do
				for x=limits.startPoint[1], limits.endPoint[1] do
					block = self.block[y][x]
					if block.type == 0 or block.ghost then
						block.act = 0
					else
						block.act = -1
					end
				end
			end
			
			self.grounds[1][seg] = {}
		end
	end
end

chunkRefreshSegment = function(self, seg)
	chunkDeactivateSegment(self, seg)
	chunkDeleteSegment(self, seg)
	local actList = chunkCalculateCollisions(self)
	chunkActivateSegRange(self, actList)
	
	return true
end

chunkRefreshSegList = function(self, blockList)
	local block
	
	for _, block in next, blockList do		
		if block.chunk == self.id then
			chunkDeactivateSegment(self, block.act)
			chunkDeleteSegment(self, block.act)
		end
	end

	local actList = chunkCalculateCollisions(self)
	chunkActivateSegRange(self, actList)
	
	return true
end

chunkActivate = function(self, onlyPhysics) 
	if not self.activated then
		if os.time() > self.timestamp + 4000 then				
			local _chunkActivateSegment = chunkActivateSegment
			local grounds = self.grounds[1]
			for _, seg in next, self.segments do
				if grounds[seg] then
					_chunkActivateSegment(self, seg)
				end
			end
		
			if not self.loaded and not onlyPhysics then chunkLoad(self) end
			self.activated = true
			self.timestamp = os.time()
			return true
		end
	end
	
	return false
end

chunkDeactivate = function(self)
	if self.activated then
		if os.time() > self.timestamp + 4000 then
			local _chunkDeactivateSegment = chunkDeactivateSegment
			local grounds = self.grounds[1]
			for _, seg in next, self.segments do
				if grounds[seg] then
					chunkDeactivateSegment(self, seg)
				end
			end

			self.activated = false
			
			return true
		end
	end
	
	return false
end

chunkDelete = function(self)
	local _chunkDeleteSegment = chunkDeleteSegment
	for _, seg in next, self.segments do
		_chunkDeleteSegment(self, seg)
	end
	
	return true
end

chunkRefresh = function(self, update)
	chunkDeactivate(self)
	if update then
		chunkDelete(self)
		chunkCalculateCollisions(self)
	end
	chunkActivate(self, true)
	
	return true
end

chunkFlush = function(self)
	chunkUnload(self)
	chunkActivate(self)
	
	return true
end

chunkUpdate = function(self, onlyPhysic, onlyVisual)
	local cc = 0
	if onlyPhysic and onlyVisual == false then
		cc = cc + (chunkRefresh(self) and 1 or 0)
	elseif onlyVisual and onlyPhysic == false then
		cc = cc + (chunkReload(self) and 1 or 0)
	elseif onlyPhysic == false and onlyVisual == false then
		cc = cc + (chunkFlush(self) and 1 or 0)
	elseif onlyPhysic == nil and onlyVisual == nil then
		cc = cc + (chunkLoad(self) and 1 or 0)
		cc = cc + (chunkActivate(self, true) and 1 or 0)
	end
	
	return cc >= 1
end 

-- ==========	PLAYER	========== --

playerNew = function(playerName, spawnPoint)
	local tfmp = tfm.get.room.playerList[playerName]
	
	local gChunk = getPosChunk(spawnPoint.x, spawnPoint.y)
	
	local self = {
		name = playerName,
		x = tfmp.x or 16320,
		y = tfmp.y or 3000,
		tx = 0,
		tx = 0,
		id = tfmp.id,
		spawnPoint = {
			x = spawnPoint and spawnPoint.x or 16320,
			y = spawnPoint and spawnPoint.y or 3000
		},
		vx = tfmp.vx or 0,
		vy = tfmp.vy or 0,
		facingRight = tfmp.facingRight or true,
		isAlive = false,
		currentChunk = gChunk or 342,
		lastChunk = gChunk,
		lastActiveChunk = gChunk,
		timestamp = os.time(),
		static = 0,
		keys = {},
		inventory = {
			bag = stackNew(27, playerName,
				stackPresets["playerBag"], 0, "bag"),
			invbar = stackNew(9, playerName,
				stackPresets["playerInvBar"], 27, "invbar"),
			craft = stackNew(5, playerName,
				stackPresets["playerCraft"], 36, "craft"),
			armor = stackNew(5, playerName,
				stackPresets["playerArmor"], 41, "armor"),
			selectedSlot = nil,
			holdingSprite = nil,
			slotSprite = nil,
			owner = playerName,
			barActive = false,
			displaying = false
		},
		
		alert = {
			text = nil,
			timestamp = 0,
			await = 1500,
			id = -1
		},
		
		trade = {
			whom = nil,
			isActive = false,
			timestamp = 0 
		}
	}
	
	return self
end
playerAlert = function(self, text, offset, color, size, await)
	if not size then size = text:match("<font[%s+?%S+]*[%s?]*size='(%d+)'[%s?]*>") or 12 end
	
	local lenght = #text:gsub("<.->", "")
	local width = math.ceil((size * lenght) + 10)
	local xpos = 400 - (width/2)
	
	if not offset then offset = 200 - (size/2) end
	
	
	local str = "<p align='center'><font face='Consolas' size='"..size.."'>" .. text .. "</font></p>"
	
	ui.addTextArea(1000, "<font color='#000000'><b>" .. str, self.name, xpos+2, offset+1, width, 0, 0x000000, 0x000000, 1.0, true)	
	ui.addTextArea(1001, "<" .. color .. "><a href='event:alert'>" .. str, self.name, xpos, offset, width, 0, 0x000000, 0x000000, 1.0, true)
	
	self.alert.timestamp = os.time()
	self.alert.await = await or 1500
end

playerCleanAlert = function(self)
	if self.alert.timestamp and os.time() > self.alert.timestamp + self.alert.await then
		eventTextAreaCallback(1001, self.name, "clear")
		self.alert.timestamp = nil
		return true
	end
	
	return false
end

--[[playerGetInventorySlot = function(self, id)
	if id then
		if id < 100 then
			if id >= 1 and id <= 36 then
				return self.inventory.bag.slot[id]
			end
		else
			if id >= 101 and id <= 105 then
				return self.inventory.craft.slot[id-100]
			end
		end
	end
	
	return nil
end]]

playerChangeSlot = function(self, stack, slot)
	local onBar = self.inventory.barActive
	local _stack
	
	if type(stack) == "string" or not stack then
		_stack = self.inventory[(stack or "invbar")]
	else
		_stack = stack
	end
	
	
	local dx, dy
	
	if type(slot) == "number" then
		if slot >= 1 and slot <= #_stack.slot then
			slot = _stack.slot[slot]
		end
	else
		if type(slot) ~= "table" then
			slot = nil
		end
	end
	
	if not slot then
		slot = _stack.slot[1]
	end
	self.inventory.selectedSlot = slot
	--local select = playerGetInventorySlot(self, slot)
	dx, dy = slot.dx, slot.dy + ((self.inventory.barActive or slot.stack ~= "invbar") and 0 or -34)-- itemReturnDisplayPositions(select, self.name)
	
	if self.inventory.slotSprite then tfm.exec.removeImage(self.inventory.slotSprite) end
	if dx and dy then
		local scale = slot.scale
		self.inventory.slotSprite = tfm.exec.addImage(
			"17e4653605e.png", "~10",
			dx-3, dy-3,
			self.name,
			scale, scale,
			0.0, 1.0,
			0.0, 0.0
		)
	end
	
	if slot.itemId ~= 0 then	
		playerAlert(self, objectMetadata[slot.itemId].name, 328 + (self.inventory.barActive and 0 or 32), "D", 14)
	else
		eventTextAreaCallback(1001, self.name, "clear")
	end
	
	playerActualizeHoldingItem(self)
end

playerDisplayInventory = function(self, list)
	local _inv = self.inventory
	self.inventory.barActive = false
	
	self.inventory.displaying = true
	
	local width = 332
	local height = 316
	ui.addTextArea(888, "", self.name, 400-(width/2), 210-(height/2), width, height, 0xD1D1D1, 0x010101, 1.0, true)
	
	stackHide(self.inventory.invbar)
	
	local stack, xo, yo, stdisp
	for _, obj in next, list do
		stack, xo, yo, stdisp = table.unpack(obj)
		stackDisplay(self.inventory[stack], xo, yo, stdisp)
	end

	playerChangeSlot(self, _inv.selectedSlot.stack, _inv.selectedSlot)
end

playerDisplayInventoryBar = function(self)
	self.inventory.barActive = true
	playerHideInventory(self)
	
	stackDisplay(self.inventory.invbar, 0, 0, true)
	
	local _inv = self.inventory
	local slot = _inv.selectedSlot
	if type(slot) == "table" then
		playerChangeSlot(self, "invbar", ((slot.id-1)%9) + 1)
	end
end

playerUpdateInventoryBar = function(self)
	local _inv = self.inventory
	local yoff = _inv.barActive and 0 or -36
	stackRefresh(_inv.invbar, 0, yoff, _inv.barActive)
	playerChangeSlot(self, "invbar", ((_inv.selectedSlot.id-1)%9) + 1)
end

playerHideInventory = function(self)
	self.inventory.displaying = false
	local _itemRemove = itemRemove
	
	stackHide(self.inventory.bag)
	stackHide(self.inventory.invbar)
	stackHide(self.inventory.craft)
	stackHide(self.inventory.armor)
	
	ui.removeTextArea(888, self.name)
	
	local element
	
	local stack = self.inventory.craft
	if stack.output then
		for key, element in next, stack.slot do
			if key < stack.output then
				playerInventoryInsert(self, element.itemId, element.amount, "bag", false)
			end
			_itemRemove(element)
		end
	end
	
	self.displaying = false
end

playerGetStack = function(self, targetStack, targetSlot)
	local stack
	
	if type(targetStack) == "table" then
		stack = targetStack.identifier
	elseif type(targetStack) == "string" then
		stack = targetStack
	else
		if targetStack == true then
			stack = self.inventory.selectedSlot.stack
		else
			if type(targetSlot) == "table" then
				stack = targetSlot.stack
			elseif targetSlot == true then
				stack = self.inventory.selectedSlot.stack
			end
		end
	end
	
	return stack
end

playerInventoryInsert = function(self, itemId, amount, targetStack, targetSlot)
	local _inv = self.inventory

	local stack, slot = playerGetStack(self, targetStack, targetSlot)

	local success = stackInsertItem(_inv[stack], itemId, amount, targetSlot)
	if not success then
		return stackInsertItem(_inv.bag, itemId, amount, targetSlot)
	end

	return success
end

playerInventoryExtract = function(self, itemId, amount, targetStack, targetSlot)
	local _inv = self.inventory
	local stack, slot = playerGetStack(self, targetStack, targetSlot)

	if _inv[stack] then
		return stackExtractItem(_inv[stack], itemId, amount, targetSlot or _inv.selectedSlot)
	end
end

playerMoveItem = function(self, origin, select, display)
	local destinatary, pass
	local newSlot = select
	
	local onBar = self.inventory.barActive
	
	if select.allowInsert then
		if self.trade.isActive then
			destinatary = room.player[self.trade.whom]
			pass = {self.name, self.trade.whom}
			select = destinatary.inventory.bag.slot[1]
		else
			destinatary = self
			pass = self.name
		end
		
		do -- Movement
			if self.keys[17] then
				origin, select, newSlot = itemMove(origin, select, 0, pass)
			elseif self.keys[16] then
				local amount = (origin.id == 0 and 0 or 1)
				origin, select, newSlot = itemMove(origin, select, amount, pass)
			end
		end
		
		if display then
			if select then
				local onBar = destinatary.inventory.barActive
				local onInv = select.stack == "invbar"
				if (onInv and onBar) or not onBar then
					itemRefresh(select, destinatary.name, 0,
						onInv and (onBar and 0 or -36) or 0
					)
				end
			end
			
			if origin then
				local onBar = self.inventory.barActive
				local onInv = origin.stack == "invbar"
				if (onInv and onBar) or not onBar then
					itemRefresh(origin, self.name, 0,
						onInv and (onBar and 0 or -36) or 0
					)
				end
			end
		end
	end
	
	return select, newSlot
end
--[[
playerHudInteract = function(self, select, blockObject)
	local origin = self.inventory.selectedSlot
	
	local destiny = self.inventory[select.stack]
	local source = self.inventory[origin.stack]
	
	local item, itemList = select:callback(self, blockObject)
	if not (item and itemList) then
		item, itemList = origin:callback(self, blockObject)
	end
end]]

playerHudInteract = function(self, stackTarget, select, blockObject)
	local origin = self.inventory.selectedSlot
	
	local destiny = self.inventory[stackTarget]
	local source = self.inventory[origin.stack]
	
	local output = source.output and source.slot[source.output] or nil
	
	local _item, itemList = select:callback(self, blockObject)
	
	if not (_item and itemList) then
		_item, itemList = origin:callback(self, blockObject)
	end
	
	if _item and itemList then
		if _item.id == origin.id then
			if select.id ~= origin.id then
				for _, element in next, itemList do
					playerInventoryExtract(
							self,
							element.itemId, 1,
							self.inventory[_item.stack],
							element
					)
					
					itemRefresh(element, self.name, 0, 0)
				end
				itemRemove(_item, self.name)
			else
				itemRefresh(_item, self.name, 0, 0)
			end
		else
			itemDisplay(_item, self.name)
		end
	else
		if output then
			itemRemove(output, self.name)
		end
	end
end
playerPlaceObject = function(self, x, y, ghost)
	if (x >= 0 and x < 32640) and (y >= 200 and y < 8392) then
		local item = self.inventory.selectedSlot
		
		if not item then return end
		
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
						local item = playerInventoryExtract(self, item.itemId, 1, true, self.inventory.selectedSlot)
						if item then
							tfm.exec.setPlayerScore(self.name, -1, true)
							playerActualizeHoldingItem(self)
							if item.stack == "invbar" then
								itemRefresh(item, self.name, 0, 0)
							end
						end
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

playerActualizeInfo = function(self, x, y, vx, vy, facingRight, isAlive)
	local tfmp = tfm.get.room.playerList[self.name]
	if timer >= awaitTime then
		self.x = x or tfmp.x
		self.y = y or tfmp.y
	end
	if timer < awaitTime or tfmp.y < 0 then
		self.x = map.spawnPoint.x
		self.y = map.spawnPoint.y
		_movePlayer(self.name, self.x, self.y)
	end
	
	self.tx = (self.x/32) - 510
	self.ty = 256 - (self.y/32)
	
	self.vx = vx or tfmp.vx
	self.vy = vy or tfmp.vy
	
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
			if self.static and not modulo.timeout then playerStatic(self, false) end
		else
			if not self.static then playerStatic(self, true) end
		end
		
		if timer >= awaitTime then
		
		local updtstr = string.format(
			"<font size='18' face='Consolas'><CH2>%s</CH2></font>\n<D><font size='13' face='Consolas'><b>Pos:</b> x %d, y %d\n<b>Last Chunk:</b> %d\n<b>Current Chunk:</b> %d (%s)\n<b>Global Grounds:</b> %d",
			self.name,
			self.tx, self.ty,
			self.lastChunk,
			self.currentChunk,
			(self.currentChunk >= 1 and self.currentChunk <= 680) and (map.chunk[self.currentChunk].activated and "+" or "-") or "NaN",
			globalGrounds
		)
		
		ui.updateTextArea(778, "<font color='#000000'><b>" .. updtstr:gsub("</?CH2>", ""):gsub("<D>", ""), self.name)
		ui.updateTextArea(777, updtstr, self.name)
		
		end
	end
end

playerReachNearChunks = function(self, range, forced)
	if timer%2000 == 0 or forced then
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

-- ==========	ITEM	========== --

itemNew = function(id, itemId, stackable, amount, desc, belongsTo)
	local self = {
		id = id,
		itemId = itemId or 0,
		stackable = stackable or true,
		amount = amount or 0,
		sprite = {},
		stack = belongsTo or "bridge",
		dx = desc.dx,
		dy = desc.dy,
		allowInsert = desc.insert,
		size = desc.size or 32,
		callback = desc.callback or dummyFunc
	}
	
	return self
end

itemCreate = function(self, itemId, amount, stackable)
	self.itemId = itemId
	self.amount = amount or 1
	self.stackable = stackable or true
	self.sprite[1] = itemId ~= 0 and objectMetadata[itemId].sprite or nil
	
	return self
end

itemRemove = function(self, playerName)
	local item = self
	
	self.itemId = 0
	self.amount = 0
	self.stackable = false
	
	if self.sprite[2] then tfm.exec.removeImage(self.sprite[2]) end
	self.sprite[1] = nil
	self.sprite[2] = nil
	
	ui.removeTextArea(self.id+500, playerName)
	ui.removeTextArea(self.id+650, playerName)
	
	return item
end

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

itemDisplaceAll = function(self, direction, source, target)	
	local newSlot
	if direction.itemId == 0 then
		stackExchangeItemsPosition(self, direction)
		newSlot = direction
	else
		if direction.itemId == self.itemId then
			if direction.amount + self.amount <= 64 then
				itemAdd(direction, self.amount)
				itemRemove(self, source.name)
				newSlot = direction
			else			
				local _amount = 64 - direction.amount
				itemAdd(direction, _amount)
				if _amount >= self.amount then
					itemRemove(self, source.name)
					newSlot = direction
				else
					itemSubstract(self, _amount)
					newSlot = self
				end
			end
		else
			if not self.allowInsert then
				local item = stackInsertItem(
					target.inventory[self.stack],
					self.itemId, self.amount, direction, false
				)
				if item then direction = item end
			else
				stackExchangeItemsPosition(self, direction)
				newSlot = direction
			end
		end
	end
	
	return newSlot or direction
end

itemDisplaceAmount = function(self, direction, amount, source, target)
	local newSlot
	if (self.itemId == direction.itemId or direction.itemId == 0) and self.stackable then
		if self.amount > amount then
			stackExtractItem(
				source.inventory[self.stack], 
				self.itemId, amount, true
			)
			
			stackInsertItem(
				target.inventory.bag,
				self.itemId, amount, direction, true
			)
			newSlot = self
		else
			if direction.itemId == 0 then
				stackExchangeItemsPosition(self, direction)
				newSlot = direction
			elseif direction.itemId == self.itemId then
				if direction.amount + amount <= 64 then
					itemAdd(direction, amount)
					itemRemove(self, source.name)
					
					newSlot = direction
				else
					amount = 64 - direction.amount
					itemAdd(direction, amount)
					if direction.amount + amount <= 64 then
						if amount >= self.amount then
							itemRemove(self, source.name)
							newSlot = direction
						else
							itemSubstract(self, amount)
							newSlot = self
						end
					else
						newSlot = direction
					end
				end
			else
				newSlot = direction
			end
		end
	end	
	
	return newSlot 
end

itemMove = function(self, direction, amount, playerName)
	local target, source
	
	if type(playerName) == "table" then
		target = room.player[ playerName[2] ]
		source = room.player[ playerName[1] ]
	else
		target = room.player[playerName]
		source = target
	end 
	
	local newSlot = source.inventory.selectedSlot
	local stack = newSlot.stack
	
	if self and direction then
		local moveCondition
		if target.name ~= source.name then
			moveCondition = (direction.stack ~= "craft")
		else
			moveCondition = (self.id ~= direction.id)
		end
		
		if moveCondition then
			newSlot = (targetPlayer ~= sourcePlayer and self or direction)
			if direction.allowInsert then
				if amount == 0 then
					newSlot = itemDisplaceAll(self, direction, source, target)
				else
					newSlot = itemDisplaceAmount(self, direction, amount, source, target)
				end
			end
		end
	end
	
	return self, direction, (newSlot or source.inventory.selectedSlot)
end

itemDisplay = function(self, playerName, xOffset, yOffset)
	if self.sprite[2] then tfm.exec.removeImage(self.sprite[2]) end
	
	local scale = self.size / 32
	local dx = self.dx + (xOffset or 0) + (8*scale)
	local dy = self.dy + (yOffset or 0) + (8*scale)

	local _ui_addTextArea, _ui_removeTextArea = ui.addTextArea, ui.removeTextArea
	
	if self.itemId ~= 0 then
		self.sprite[2] = tfm.exec.addImage(
			self.sprite[1],
			"~"..(self.id+100),
			dx, dy,
			playerName,
			scale/1.8823, scale/1.8823,
			0, 1.0,
			0, 0
		)
		
		if self.stackable and self.amount > 1 then
			local text = "<p align='center'><font face='Consolas' size='"..(12.4*scale).."'>" .. self.amount
			local xpos = dx-(9*scale)
			local scl = 34*scale
			_ui_addTextArea(self.id+500, "<font color='#000000'><b>" .. text, playerName, xpos+1, dy+1, scl, 0, 0x000000, 0x000000, 1.0, true)
			_ui_addTextArea(self.id+650, "<VP>" .. text, playerName, xpos, dy, scl, 0,	0x000000, 0x000000,	1.0, true)
		else
			_ui_removeTextArea(self.id+500, playerName)
			_ui_removeTextArea(self.id+650, playerName)
		end
	else
		self.sprite[2] = nil
		_ui_removeTextArea(self.id+500, playerName)
		_ui_removeTextArea(self.id+650, playerName)
	end
	
	_ui_addTextArea(
		self.id+350,
		"<textformat leftmargin='1' rightmargin='1'><a href='event:"..self.stack.."'>\n\n\n\n\n\n\n\n\n\n\n\n</a></textformat>", 
		playerName, 
		self.dx + (xOffset or 0) - (1*scale), self.dy + (yOffset or 0) - (1*scale), --350
		32*scale, 32*scale, 
		0x000000, 0x000000, 
		0, true
	)
	
	return {dx, dy}
end

itemHide = function(self, playerName)
	if self.sprite[2] then
		tfm.exec.removeImage(self.sprite[2])
		self.sprite[2] = nil
	end
	
	local _ui_removeTextArea = ui.removeTextArea
	_ui_removeTextArea(self.id+350, playerName)
	_ui_removeTextArea(self.id+500, playerName)
	_ui_removeTextArea(self.id+650, playerName)
end

itemRefresh = function(self, playerName, xOffset, yOffset)
	itemHide(self, playerName)
	itemDisplay(self, playerName, xOffset, yOffset)
end


-- ==========	INVENTORY	========== --

stackNew = function(size, owner, dir, idoffset, name)
    if not dir then dir = {} end
    
    local stack = {
        slot = {},
        identifier = name,
        owner = owner,
        sprite = {
            dir.sprite,
            {
                x=dir.xStart or 0,
                y=dir.yStart or 0
            },
            nil
        },
        offset = idoffset,
        output = dir.output,
        displaying = false
    }
    
    local _itemNew = itemNew
    
    local id = 0
    local ddat = {}
    local slot = dir.slot or {}
    
    do
        local gsize = dir.size or 32
        local glns = dir.lines or 1
        local gcls = dir.collumns or 1

        local ygsep = dir.ySeparation or 0
        local xgsep = dir.xSeparation or 0

        local gxstr = (dir.xStart or 0) + (dir.xOffset or 0)
        local gystr = (dir.yStart or 0) + (dir.yOffset or 0)

        local gcall = dir.callback or dummyFunc
        local lcall, ccall
        local lines = dir.line or {}
        local collumns = dir.collumn or {}

        local xsep, ysep = 0, 0
        local ystr, xstr
        local ln, cls
        local yoff, xoff

        for y=1, dir.lines do
            ln = lines[y]
            ystr = ln and (ln.str or gystr) or gystr
            ysep = ysep + (ln and (ln.sep or ygsep) or ygsep)
            lcall = ln and (ln.callback or gcall) or gcall
            
            xsep = 0
            for x=1, dir.collumns do
                cls = collumns[x]
                
                xsep = xsep + (cls and (cls.sep or xgsep) or xgsep)
                xstr = cls and (cls.str or gxstr) or gxstr
                ccall = cls and (cls.callback or gcall) or gcall

                id = id + 1
                ddat[id] = {
                    dx = xstr + ((gsize*(x-1)) + xsep),
                    dy = ystr + ((gsize*(y-1)) + ysep),
                    callback = lcall ~= dummyFunc and lcall or ccall,
                    size = gsize,
                    insert = true,
                }
            end
        end
    end
    
    for i=1, size do
        if slot[i] then 
            local ref = (ddat[i]) or {}
            ddat[i] = {
                dx = slot[i].dx or ref.dx,
                dy = slot[i].dy or ref.dy,
                insert = (slot[i].insert ~= nil) and slot[i].insert or ref.insert,
                size = slot[i].size or ref.size,
                callback = slot[i].callback or ref.callback
            }
        end
        stack.slot[i] = _itemNew(idoffset + i, 0, false, 0, ddat[i], stack.identifier)
    end
    
    return stack
end

stackFill = function(self, element, amount)
    local _itemCreate = itemCreate
    
    if element ~= 0 then
        for i=1, #self.slot do
            _itemCreate(self.slot[i], element, amount, amount ~= 0)
        end
        
        return true
    else
        return stackEmpty(self)
    end
end
 
stackEmpty = function(self)
    local _itemRemove = itemRemove
    
    for i=1, #self.slot do
        _itemRemove(self.slot[i], self.owner)
    end
    
    return true 
end
stackFindItem = function(self, itemId, canStack)
	for _, item in next, self.slot do
		if item.itemId == itemId then
			if canStack then
				if item.stackable and item.amount < 64 then
					return item
				end
			else
				return item
			end
		end
	end

	return nil
end

stackCreateItem = function(self, itemId, amount, targetSlot)
	local slot = targetSlot or stackFindItem(self, 0)

	if slot then
		return itemCreate(slot, itemId, amount, (amount > 0))
	end
	
	return nil
end

stackInsertItem = function(self, itemId, amount, targetSlot)
	local item = stackFindItem(self, itemId, true)
	
	if targetSlot ~= nil then
		if type(targetSlot) == "boolean" then
			if targetSlot then
				item = room.player[self.owner].inventory.selectedSlot
			end
		elseif type(targetSlot) == "number" then
			if targetSlot <= #self.slot then
				item = self.slot[targetSlot]
			end
		elseif type(targetSlot) == "table" then
			item = targetSlot
		end
		
		if item then
			if item.itemId ~= 0 then
				if (item.stackable and item.amount + amount > 64) or item.itemId ~= itemId then
					item = stackFindItem(self, itemId, true)
				end
			end
		else
			return nil
		end
	end
	
	if item then
		if item.stackable and item.amount + amount <= 64 and item.itemId == itemId then
			itemAdd(item, amount)
			return item
		else
			return stackCreateItem(self, itemId, amount, item)
		end
	else
		return stackCreateItem(self, itemId, amount, item)
	end

	return item
end

stackExtractItem = function(self, itemId, amount, targetSlot)
	local item = stackFindItem(self, itemId)
	local own = room.player[self.owner]
	
	if targetSlot ~= nil then
		if type(targetSlot) == "boolean" then
			if targetSlot then
				item = own.inventory.selectedSlot
			end
		elseif type(targetSlot) == "number" then
			item = own.inventory[own.inventory.selectedSlot.stack].slot[targetSlot]
		elseif type(targetSlot) == "table" then
			item = targetSlot 
		end
	end
	
	if item then
		if item.stackable then
			local fx = item.amount - (amount or 1)
			if fx <= 0 then
				return itemRemove(item, self.owner)
			else
				itemSubstract(item, amount)
				return item
			end
		else
			return itemRemove(item, self.owner)
		end
	end
	
	
	return item
end

stackFetchCraft = function(self, limit)
	local lookup
	local k = 1
	local m = 0
	local itemList = {}
	
	local _table_insert = table.insert
	
	for i=1, limit do
		m = i
		
		if limit == 4 and i == 3 then
			k = k + 1
		end
		
		if lookup then
			k = k + 1
			if self.slot[m].itemId == craftsData[lookup][1][k] then
				_table_insert(itemList, self.slot[m])
				if k == #craftsData[lookup][1] then
					return craftsData[lookup][2], itemList
				end
			else
				if k <= #craftsData[lookup][1] then
					lookup = nil
					k = 0
					break
				else
					return craftsData[lookup][2], itemList
				end
			end
		else
			for j, craft in next, craftsData do
				if self.slot[m].itemId == craft[1][1] then
					lookup = j
					k = 1
					_table_insert(itemList, self.slot[m])
					
					if #craftsData[lookup][1] == 1 then
						return craftsData[lookup][2], itemList
					else
						break
					end
				end
			end
		end
	end
end


stackExchangeItemsPosition = function(item1, item2)
	local exchange = {
		itemId = item1.itemId,
		stackable = item1.stackable,
		amount = item1.amount,
		sprite = item1.sprite--, stack = item1.stack
	}
	
	item1.itemId = item2.itemId
	item1.stackable = item2.stackable
	item1.amount = item2.amount
	item1.sprite = item2.sprite
	--item1.stack = item2.stack
	
	item2.itemId = exchange.itemId
	item2.stackable = exchange.stackable
	item2.amount = exchange.amount
	item2.sprite = exchange.sprite
	--item2.stack = exchange.stack
end
stackDisplay = function(self, xOffset, yOffset, displaySprite)
    local _itemDisplay = itemDisplay
    
    if displaySprite then
        if self.sprite and self.sprite[1] then
            if self.sprite[3] then
                tfm.exec.removeImage(self.sprite[3])
            end
            
            self.sprite[3] = _tfm_exec_addImage(
                self.sprite[1], "~1",
                self.sprite[2].x+(xOffset or 0), self.sprite[2].y+(yOffset or 0),
                self.owner,
                1.0, 1.0,
                0, 1.0,
                0, 0
            )
        end
    end

    
    for i=1, #self.slot do
        _itemDisplay(self.slot[i], self.owner, xOffset or 0, yOffset or 0)
    end
    
    self.displaying = true
    
    return true
end

stackHide = function(self)
    local _itemHide = itemHide
    
    if self.sprite[3] then
        _tfm_exec_removeImage(self.sprite[3])
        self.sprite[3] = nil
    end
    
    for i=1, #self.slot do
        _itemHide(self.slot[i], self.owner)
    end
    
    self.displaying = false
    
    return true
end

stackRefresh = function(self, xOffset, yOffset, displaySprite)
    stackHide(self)
    stackDisplay(self, xOffset, yOffset, displaySprite)
end

-- ==========	WORLDHANDLE	========== --

worldRefreshChunks = function()
	local _chunkDeactivate, chunkList = chunkDeactivate, map.chunk
	for i=1, 680 do
		_chunkDeactivate(chunkList[i])
	end

	for _, player in next, room.player do
		player.timestamp = os.time()
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
	
	for i=1, #chunkList do
		if handle[i] then
			if counter < peak and calls < lcalls then
				lapse = _os_time()
				ok, result = _pcall(handle[i][2], chunkList[handle[i][1]], true)
				if ok then
					if result then
						if handle[i][2] ~= chunkUnload then
							calls = calls + 1
						else
							calls = calls + 0.5
						end
					end
					
					handle[i] = nil
				else
					if handle[i][2] == chunkUnload then
						error("Issue on chunkUnload:\n\n" .. result)
					else
						handle[i][2] = chunkUnload
					end
				end
				counter = counter + (_os_time() - lapse)
			else
				print(string.format("<R>Chunk timeout ~ ~ ~</R>\n<D><T>Calls:</T> %f/%d p\n<T>Runtime:</T> %d/%d ms", calls, lcalls, counter, peak))
				map.timestamp = _os_time()
				counter = peak
				break
			end
		end
	end
	
	if calls ~= 0 then
		map.timestamp = _os_time()
	end
	
	--modulo.runtimeLapse = counter
	
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
		yk = origin.dy+((i*32)-1)
		for j=-range, range do
			self = _getPosBlock(origin.dx+((j*32)-1), yk)
			
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
				block = _getPosBlock(xOrigin + (tile[3]*32), yOrigin - (tile[4]*32))
				if block.type == 0 or overwrite then blockCreate(block, tile[1]+type, tile[2], false) end
			end
		end
	end
end 

getFixedSpawn = function()
	local point, surfp
	for i=0, 7 do
		point = (637-(85*i))
		for j=32, 1, -1 do
			surfp = map.chunk[point].block[j][6]
			if surfp.type == 0 --[[or surfp.ghost ]]then
				return {x=16320, y=surfp.dy-100}
			end
		end
	end
	
	return {x=16320, y=184}
end

generateBoundGrounds = function()
	local gc = 0
	local bodydef = {type=14, width=32, height=3000}
	local xpos, ypos
	for i=1, 3 do
		ypos = ((3000*(i-1))+1500)-608
		addPhysicObject(130545+(gc*2), -16, ypos, bodydef)
		addPhysicObject(130546+(gc*2), 32656, ypos, bodydef)
		gc = gc + 1
	end
	
	bodydef = {type=14, width=3000, height=32, friction=0.2}
	for i=1, 11 do
		xpos = ((3000*(i-1))+1500)-180
		addPhysicObject(gc, xpos, 8376, bodydef)
		gc = gc + 1
	end
end

createNewWorld = function(heightMaps)
	local _math_random, _math_floor, _math_ceil = math.random, math.floor, math.ceil
	local _chunkNew, _structureCreate, _chunkCalculateCollisions = chunkNew, structureCreate, chunkCalculateCollisions
	local _ui_updateTextArea, _tfm_exec_addImage, _tfm_exec_removeImage = ui.updateTextArea, tfm.exec.addImage, tfm.exec.removeImage
	local _string_format = string.format
	local chunkList = map.chunk
	
	local count = 0
	
	local bar
	
	local angle = math.rad(270)
	
	local updatePercentage = function()
		local percentage = _math_round(count/13.60, 2)
		_ui_updateTextArea(999, _string_format("<p align='left'><font size='16' face='Consolas' color='#ffffff'>Loading...\t<D>%f%%</D></font></p>", percentage), nil)
		if bar then _tfm_exec_removeImage(bar) end
		bar = _tfm_exec_addImage("17d441f9c0f.png", "~1", 60, 375, nil, 1.1, 0.025*count,--[[0.015625*count, 0.5,]] angle, 1.0, 0.0, 0.0)
		
		count = count + 1
	end
	
	local point, surfp
	for i=1, 680 do
		chunkList[i] = _chunkNew(i, false, false, 1, heightMaps)
		updatePercentage()
	end
	
	map.spawnPoint = getFixedSpawn()
	xmlLoad = string.format(xmlLoad, map.spawnPoint.x, map.spawnPoint.y)
	
	for i=1, 1040 do
		if _math_random(15) == 1 then
			_structureCreate(1, ((i-1)*32)+16, ((256-heightMaps[1][i])*32)+16)
		end
	end
	
	for i=1, 680 do
		_chunkCalculateCollisions(chunkList[i])
		updatePercentage()
	end
	
	_tfm_exec_removeImage(bar)

	math.randomseed(os.time())
end

startPlayer = function(playerName, spawnPoint)
	if not room.player[playerName] then
		room.player[playerName] = playerNew(playerName, spawnPoint)
		local _system_bindKeyboard = system.bindKeyboard
		for k=0, 200 do
			_system_bindKeyboard(playerName, k, false, true)
			_system_bindKeyboard(playerName, k, true, true)
			room.player[playerName].keys[k+1] = false
		end
		system.bindMouse(playerName, true)
		
		tfm.exec.setAieMode(true, 5.0, playerName)
		eventPlayerDied(playerName, true)
		
		ui.addTextArea(777, "", playerName, 5, 25, 200, 100, 0x000000, 0x000000, 1.0, true)
		ui.addTextArea(778, "", playerName, 5.5, 26, 200, 100, 0x000000, 0x000000, 1.0, true)
	
		playerDisplayInventoryBar(room.player[playerName])
		playerChangeSlot(room.player[playerName], "invbar", 1)
		
		if timer > 3000 then
			playerReachNearChunks(room.player[playerName], 1, true)
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
    y = y - 200
	
	local destr = range * (3/4)
	local ghost = range + (range-destr)
	
	local chunks = {}

	local _table_insert = function(tbl, el)
		if not tbl then tbl = {} end
			
		tbl[#tbl+1] = el
		
		return tbl
	end
    
    for yf=-range, range do
        yy = y + (yf*32)
		
        for xf=-range, range do
            xx = x + (xf*32)
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

	
	for chunk, blockList in next, chunks do
		if blockList then
			chunkRefreshSegList(map.chunk[chunk], blockList)
		end
	end
	
	tfm.exec.explosion(x, y+200, 15*power, range*32, false)
end


-- ==========	EVENTS	========== --

onEvent("LoadFinished", function()
	modulo.loading = false
  
	ui.removeTextArea(999, nil)
	for _, img in next, modulo.loadImg[2] do
		tfm.exec.removeImage(img)
	end

	tfm.exec.setWorldGravity(0, 10)
	--ui.addTextArea(777, "", nil, 0, 25, 300, 100, 0x000000, 0x000000, 1.0, true)
end)


local _os_time = os.time
onEvent("Loop", function(elapsed, remaining)
	if modulo.loading then
    if timer == 0 then
      tfm.exec.removeImage(modulo.loadImg[2][3])
      ui.addTextArea(999,
      "", nil,
      50, 200,
      700, 0,
      0x000000,
      0x000000,
      1.0, true
    )
		elseif timer <= awaitTime then
			ui.updateTextArea(999, string.format("<font size='48'><p align='center'><D><font face='Wingdings'>6</font>\n%s</D></p></font>", ({'.', '..', '...'})[((timer/500)%3)+1]), nil) -- Finishing
		else
			eventLoadFinished()
		end
	end
end)

onEvent("Loop", function(elapsed, remaining)
	if timer --[[>=]]% 10000 == 0 and modulo.loading then
		--error("Script loading failed.", 2)
		print(timer)
	end
	
	do
		for _, player in next, room.player do
			if player.isAlive then
				playerLoopUpdate(player)
				
				if modulo.loading then
					if map.chunk[player.currentChunk].activated then
						awaitTime = -1000
					else
						if timer >= awaitTime - 1000 then
							awaitTime = awaitTime + 500
						end
					end
				end
				
				if player.static and _os_time() > player.static then
					playerStatic(player, false)
				end
			end
			
			playerCleanAlert(player)
		end
	
		if _os_time() > map.timestamp + 4000 then
			if modulo.runtimeLapse > 1 then
				print(("<O><b>Runtime reset:</b></O> <D>%d ms</D>"):format(modulo.runtimeLapse))
				modulo.timeout = false
			end
			modulo.runtimeLapse = 0
		end
		
		do
			if modulo.runtimeLapse < modulo.runtimeLimit then
				handleChunksRefreshing()
			end
			
			if modulo.runtimeLapse >= modulo.runtimeLimit then
				for _, player in next, room.player do
					if not player.static then
						playerStatic(player, true)
						playerAlert(player, "<b>Module Timeout", nil, "CEP", 48, 3900)
					end
				end
				modulo.timeout = true
			end
		end
			--[[if tt >= 3 then
			map.loadingTotalTime = map.loadingTotalTime + tt
			map.totalLoads = map.totalLoads + 1
			map.loadingAverageTime = _math_round(map.loadingTotalTime / map.totalLoads, 2)
			if room.isTribe then
				local color
				if tt < 10 then color = "VP" elseif tt >= 10 and tt < 20 then color = "CEP" else color = "R" end
				print(string.format("<V>[Event Loop]</V> Chunks updated in <%s>%d ms</%s> (avg. %f ms)", color, tt, color, map.loadingAverageTime))
			end
		end]]
	end
end)

onEvent("Loop", function(elapsed, remaining)
	local HNDL = actionsHandle
	local lenght = #HNDL
	
	local i, action = 1
	local ok, result
	
	local _table_unpack = table.unpack
	
	while i <= lenght do
		action = HNDL[i]
		if _os_time() >= action[1] then
			if modulo.runtimeLapse < modulo.runtimeLimit then
				local tt = _os_time()
				ok, result = pcall(action[2], _table_unpack(action[3]))
				if not ok then 
					print(("[<D>Warning</D>] %s"):format(result))
				end
				table.remove(HNDL, i)
				lenght = lenght - 1
				
				modulo.runtimeLapse = modulo.runtimeLapse + (_os_time() - tt)
				print(modulo.runtimeLapse)
			else
				break
			end
		else
			i = i + 1
		end
	end
end)

onEvent("Loop", function(elapsed, remaining)
	if globalGrounds > 512 then
		--print("<CEP> Warning! <R>" .. globalGrounds .. "</R> is above the safe physic objects count!")--worldRefreshChunks()
		if globalGrounds >= 712 then -- 512
			error(string.format("Physic system destroyed: <CEP>Limit of physic objects reached:</CEP> <R>%d/512", globalGrounds), 2)
		end
	end
	
	timer = timer + 500
end)

onEvent("Keyboard", function(playerName, key, down, x, y)
	if timer > awaitTime and room.player[playerName] then
		if down then
			room.player[playerName].keys[key] = true
			
			if (key >= 49 and key <= 57) or (key >= 97 and key <= 105) then
				local slot = key - (key <= 57 and 48 or 96)
				playerChangeSlot(room.player[playerName], "invbar", slot)
			end
			
			if key == 72 then -- H
				eventTextAreaCallback(0, playerName, "help")
			elseif key == 46 then -- delete
				local item = playerGetInventorySlot(room.player[playerName], room.player[playerName].inventory.selectedSlot)
				if item then itemRemove(item, playerName) end
			elseif key == 69 then -- E
				if room.player[playerName].inventory.displaying then
					playerHideInventory(room.player[playerName])
					playerDisplayInventoryBar(room.player[playerName])
				else
					playerDisplayInventory(
						room.player[playerName],
						{{"bag", 0, 0, true}, 
						{"invbar", 0, -36, false}, 
						{"craft", 0, 0, true}, 
						{"armor", 0, 0, true}}
					)
				end
			elseif key == 71 then -- G
				if room.player[playerName].trade.isActive then 
					eventPopupAnswer(11, playerName, "canceled")
				else
					ui.addPopup(10, 0, "<p align='center'>Tradings are disabled currently, sorry.</p>"--[[Type the name of whoever you want to trade with."]], playerName, 250, 180, 300, true)
				end
			end
		else
			room.player[playerName].keys[key] = false
		end
		
		if room.player[playerName] and timer > awaitTime then
			local facingRight
			if key < 4 and key%2 == 0 then
				facingRight = key == 2
			end
			
			if room.player[playerName].isAlive then
				playerActualizeInfo(room.player[playerName], x, y, _, _, facingRight)
			end
		end
	end
end)

onEvent("Mouse", function(playerName, x, y)
	if timer > awaitTime and room.player[playerName] then
		if room.player[playerName].isAlive then
			if (x >= 0 and x < 32640) and (y >= 200 and y < 8392) then
				local block = getPosBlock(x, y-200)
				local isKeyActive = room.player[playerName].keys
				if isKeyActive[18] then -- debug
					if isKeyActive[17] then
						printt(map.chunk[block.chunk].grounds[1][block.act])
					else
						printt(block)
					end
				elseif isKeyActive[17] then
					playerBlockInteract(room.player[playerName], getPosBlock(x, y-200))
				elseif isKeyActive[16] then
					playerPlaceObject(room.player[playerName], x, y, isKeyActive[32])
				else
					if block.id ~= 0 then
						playerDestroyBlock(room.player[playerName], x, y)
					else
						room.player[playerName].inventory.selectedSlot:onHit(x, y)
					end
				end
			end
		end
	end
end)

onEvent("PlayerDied", function(playerName, override)
	if room.player[playerName] then
		room.player[playerName].isAlive = false
		if override then
			tfm.exec.respawnPlayer(playerName)
		else
			ui.addTextArea(42069, "\n\n\n\n\n\n\n\n<p align='center'><font face='Soopafresh' size='42'><R>You've died.</R></font>\n\n\n<font size='28' face='Consolas' color='#ffffff'><a href='event:respawn'>Respawn</a></font></p>", playerName, 0, 0, 800, 400, 0x010101, 0x010101, 0.4, true)
		end
	end
end)

onEvent("PlayerRespawn", function(playerName)
	if room.player[playerName] then
		_movePlayer(playerName, map.spawnPoint.x, map.spawnPoint.y, false, 0, -8)
		playerActualizeInfo(room.player[playerName], map.spawnPoint.x, map.spawnPoint.y, _, _, true, true)
	end
end)

onEvent("NewPlayer", function(playerName)
	startPlayer(playerName, map.spawnPoint)
	tfm.exec.addImage("17e464d1bd5.png", "?512", 0, 8, playerName, 32, 32, 0, 1.0, 0, 0)
	ui.addTextArea(0, "<p align='right'><font size='18' face='Consolas'> <a href='event:help'>Help</a> ", playerName, 600, 375, 200, 25, 0x000000, 0x000000, 1.0, true)
	
	if not room.isTribe then
		tfm.exec.lowerSyncDelay(playerName)
	end
end)

onEvent("PlayerLeft", function(playerName)
	room.player[playerName] = nil
end)

onEvent("ChatCommand", function(playerName, command)
	local args = {}
	
	for arg in command:gmatch("%S+") do
		args[#args+1] = arg
	end
	command = args[1]
	
	if args[1] == "help" then
		eventTextAreaCallback(0, playerName, "help")
	elseif args[1] == "seed" then
		ui.addPopup(169, 0, string.format("<p align='center'>World's seed:\n%d", map.seed), playerName, 300, 180, 200, true)
	elseif args[1] == "tp" then
		if room.isTribe or playerName == modulo.creator then
			local pa = tonumber(args[2])
			local pb = tonumber(args[3])
			
			local withinRange = function(a, b) return (a >= 0 and a <= 32640) and (b >= 0 and b <= 8392) end
			
			if pa and pb then
				if withinRange(pa, pb) then _movePlayer(playerName, pa, pb) end
			elseif not pa or not pb then
				local pl = room.player[ args[2] ]
				if pl then
					if pl.isAlive then
						pa = pl.x
						pb = pl.y
						if withinRange(pa, pb) then _movePlayer(playerName, pa, pb) end
					end
				end
			end
		end
	elseif args[1] == "debug" then
		local player = room.player[args[2]]
		
		if player then printt(player, {"keys", "slot", "interaction"}) end
	elseif args[1] == "announce" or args[1] == "chatannounce" then
		if playerName == modulo.creator then
			local _output = "<CEP><b>[Room Announcement]</b></CEP> <D>"
			for i=2, #args do
				_output = _output .. args[i] .. " "
			end
			_output = _output .. "</D>"
      
			if args[1] == "chatannounce" then
				tfm.exec.chatMessage(_output, nil)
			else
			ui.addTextArea(42069, "<a href='event:clear'><p align='center'>" .. _output, nil, 100, 50, 600, 300, 0x010101, 0x010101, 0.4, true)
			end
		end
	elseif args[1] == "stackFill" then
		local player = room.player[args[4] or playerName]
		if playerName == modulo.creator then
			stackFill(player.inventory.bag, tonumber(args[2]), tonumber(args[3]) or 64)
		end
	end
end)


onEvent("TextAreaCallback", function(textAreaId, playerName, eventName)
	if textAreaId == 0 then
		if eventName == "help" then
			local helpText = "<p align='center'><font size='48' face='Consolas'><D>Help</D></font></p>\n\n<font face='Consolas'>Welcome to <J><b>"..(modulo.name).."</b></J>, script created by <V>"..(modulo.creator).."</V>.\n\n<b>CONTROLS:</b>\n- <u>CLICK:</u> Damage blocks.\n- <u><V>SHIFT</V> + CLICK:</u> Places a block, from selected slot.\n- <u>[1- 9]:</u> Select a slot from inventory. You can also click on them to select.\n- [E]: Opens the main inventory.\n- <u><V>CTRL</V> + CLICK</u>:  Interacts with a block, when in inventory it exchanges the position of an item from a previous slot to the new clicked one.\n\n\nIf you find any bugs, please report to my Direct Messages in the Forum or through my Discord: <CH>Cap#1753</CH>.\n\nHope you enjoy!"
			ui.addTextArea(200, helpText, playerName, 150, 50, 500, 300, 0x010101, 0x010101, 0.67, true)
			ui.addTextArea(201, "<font size='16'><a href='event:clear'><R><b>X</b></R></a>", playerName, 630, 55, 0, 0, 0x000000, 0x000000, 1.0, true)
		end
	end
	
	if eventName == "respawn" then
		eventTextAreaCallback(textAreaId, playerName, "clear")
		tfm.exec.respawnPlayer(playerName)
	end
end)

onEvent("TextAreaCallback", function(textAreaId, playerName, eventName)
	if eventName == "clear" or eventName == "alert" then
		ui.removeTextArea(textAreaId, playerName)
		if textAreaId == 201 then
			ui.removeTextArea(200, playerName)
		elseif textAreaId == 1001 then
			ui.removeTextArea(1000, playerName)
		end
	end
end)

onEvent("TextAreaCallback", function(textAreaId, playerName, eventName)
	if timer > awaitTime and room.player[playerName] then
		--if playerName then return end
		if not eventName then return end
		--eventName = eventName or "bridge"
		local Player = room.player[playerName]

		local targetStack = Player.inventory[eventName]
		if not targetStack then return end
		local newSlot = targetStack.slot[textAreaId - (350 + targetStack.offset)]
		local select = (newSlot)
		
		if (Player.keys[17] or Player.keys[16]) and select then
			local origin = Player.inventory.selectedSlot
			if origin then
				select, newSlot = playerMoveItem(Player, origin, select, true)
				playerHudInteract(Player, eventName, select)
			end
		end
		
		if not newSlot then newSlot = Player.inventory.selectedSlot end
		playerChangeSlot(room.player[playerName], newSlot.stack, newSlot)
	end
end)

onEvent("PopupAnswer", function(popupId, playerName, answer)
	return nil
	--[[
	if room.player[playerName] then
		if popupId == 10 then
			if room.player[playerName].trade.timestamp < os.time() - 15000 then
				if room.player[answer] then
					if playerName ~= answer then
						if not room.player[answer].trade.whom then
							playerInitTrade(room.player[playerName], answer)
							playerInitTrade(room.player[answer], playerName)
							ui.addPopup(11, 1, "<p align='center'>Do you want to trade with <D>"..(playerName).."</D>?", answer, 325, 100, 150, true)
						else
							ui.addPopup(10, 0, "<p align='center'>The user <CEP>"..(answer).."</CEP> is currently trading with another person.", playerName, 250, 180, 300, true)
						end
					else
						ui.addPopup(10, 0, "<p align='center'>You can't trade with yourself.", playerName, 250, 180, 300, true)
					end
				else
					ui.addPopup(10, 0, "<p align='center'>Sorry, the user <CEP>"..(answer).."</CEP> is invalid or does not exist.", playerName, 250, 180, 300, true)
				end
			else
				ui.addPopup(10, 0,
				string.format("<p align='center'>You have to wait %ds in order to start a new trade.", ((room.player[playerName].trade.timestamp + 15000)-os.time())/1000), playerName, 250, 180, 300, true)
			end
		elseif popupId == 11 then
			if answer == "yes" then
				room.player[playerName].trade.isActive = true
				room.player[room.player[playerName].trade.whom].trade.isActive = true
				
				ui.addTextArea (1002, "<b><font face='Consolas'><p align='right'><CEP>Trading with</CEP> <D>"..(room.player[playerName].trade.whom).."</D>", playerName, 600, 20, 200, 0, 0x000000, 0x000000, 1.0, true)
				ui.addTextArea (1002, "<b><font face='Consolas'><p align='right'><CEP>Trading with</CEP> <D>"..(playerName).."</D>", room.player[playerName].trade.whom, 600, 20, 200, 0, 0x000000, 0x000000, 1.0, true)
			elseif answer == "no" then
				ui.addPopup(10, 0, "<p align='center'><D>"..(playerName).."</D> has <R>rejected</R> the trade.", room.player[playerName].trade.whom, 250, 180, 300, true)
				eventPopupAnswer(11, playerName, "CANCEL")
			elseif answer == "canceled" then
				ui.addPopup(10, 0, "<p align='center'><D>"..(playerName).."</D> has <CEP>canceled</CEP> the trade.", room.player[playerName].trade.whom, 250, 180, 300, true)
				ui.addPopup(10, 0, "<p align='center'>Trade has been canceled successfully.", playerName, 250, 180, 300, true)
				ui.removeTextArea(1002, room.player[playerName].trade.whom)
				ui.removeTextArea(1002, playerName)
				
				eventPopupAnswer(11, playerName, "CANCEL")
			end
			
			if answer == "CANCEL" then
				playerCancelTrade(room.player[room.player[playerName].trade.whom])
				playerCancelTrade(room.player[playerName])
			end
		end
	end]]
end)


onEvent("NewGame", function()
	if timer <= 10000 then
		generateBoundGrounds()
		tfm.exec.setGameTime(0)
		ui.setMapName(modulo.name)
		tfm.exec.setWorldGravity(0, 0)
		
		for name, _ in next, tfm.get.room.playerList do
			eventNewPlayer(name)
			eventPlayerRespawn(name)
		end
	else
		--appendEvent(3100, tfm.exec.newGame, xmlLoad)
		error("New map loaded.")
	end
end)

-- ==========	MAIN	========== --

local main = function()	
  do
    ui.addTextArea(999,
      "<font size='16' face='Consolas' color='#ffffff'><p align='left'>Initializing...</p></font>", nil,
      55, 320,
      690, 0,
      0x000000,
      0x000000,
      1.0, true
    )
    modulo.loading = true
  
    --local scl = 0.8
    modulo.loadImg[2] = {
      tfm.exec.addImage(modulo.sprite, "~777", 70, 50, nil, 1.0, 1.0, 0, 1.0, 0, 0),
      tfm.exec.addImage(modulo.loadImg[1][1], ":42", 0, 0, nil, 1.0, 1.0, 0, 1.0, 0, 0),
      tfm.exec.addImage(modulo.loadImg[1][2], ":69", 55, 348, nil, 1.0, 1.0, 0, 1.0, 0, 0)
    }
    
    tfm.exec.setGameTime(0)
    ui.setMapName(modulo.name) 
  end
  
	for i=0, 512 do
		if not objectMetadata[i] then objectMetadata[i] = {} end
		local _ref = objectMetadata[i] 
		objectMetadata[i] = {
			name = _ref.name or "Null",
			drop = _ref.drop or 0,
			durability = _ref.durability or 18,
			glow = _ref.glow or 0,
			translucent = _ref.translucent or false,
			sprite = _ref.sprite or "17e1315385d.png",
			particles = _ref.particles or {},
			interact = _ref.interact or false,
			
			handle = _ref.handle,
			
			onCreate = _ref.onCreate or dummyFunc,
			onPlacement = _ref.onPlacement or dummyFunc,
			onDestroy = _ref.onDestroy or dummyFunc,
			onInteract = _ref.onInteract or dummyFunc,
			onHit = _ref.onHit or dummyFunc,
			onDamage = _ref.onDamage or dummyFunc,
			onContact = _ref.onContact or dummyFunc,
			onUpdate = _ref.onUpdate or dummyFunc,
			onAwait = _ref.onAwait or dummyFunc
		}
	end
	
	do
		tfm.exec.disableAfkDeath(true)
		tfm.exec.disableAutoNewGame(true)
		tfm.exec.disableAutoScore(true)
		tfm.exec.disableAutoShaman(true)
		tfm.exec.disableAutoTimeLeft(true)
		tfm.exec.disablePhysicalConsumables(true)
		tfm.exec.disableWatchCommand(true)
		
		system.disableChatCommandDisplay(nil)
		
		
		if not room.isTribe then
			tfm.exec.setRoomMaxPlayers(7)
			tfm.exec.setPlayerSync(nil) 
			tfm.exec.disableDebugCommand(true)
		end
	end
	
	map.seed = os.time() or 2^31
	math.randomseed(map.seed)
	local heightMaps = {}
	
	for i=1, 7 do
		heightMaps[i] = generatePerlinHeightMap(
			nil, -- Seed
			i==1 and 30 or 20, -- Amplitude
			i==1 and 24 or 12, -- Wave Length
			i==1 and 64 or 60-((i-1)*20), -- Surface Start
			1040, -- Width
			i==1 and 128 or 140-((i-1)*20)
		)
		map.heightMaps[i] = heightMaps[i]
	end
	createNewWorld(heightMaps) -- newMap
	
	tfm.exec.newGame(xmlLoad)
end


local defTrunkDestroy = function(self, Player, norep)
	if not self.ghost then return end
	
	local upward = getPosBlock(self.dx + 16, self.dy - 216)
	local leavetype = self.type + 1
	
	if upward.type == leavetype then
		local dx, dy, yy = self.dx + 16, self.dy - 184
		local _getPosBlock, block = getPosBlock
		local h = 1
		
		for y=-4, -1 do
			yy = dy + (y*32)
			if y >= -2 then h = 2 end
			for x=-h, h do
				block = _getPosBlock(dx + (x*32), yy)
				
				if block.type == leavetype then
					block.timestamp = self.timestamp
					appendEvent(
						math.random(15,75)*1000,
						function(self, lt, pl)
							if self.timestamp == lt then
								blockDestroy(self, true, pl)
								blockDestroy(self, true, pl)
							end
						end,
						block, (self.timestamp), Player
					)
				end
			end
		end
	end
end

stackPresets = {
	["playerBag"] = {
		size = 32,
		lines = 4,
		collumns = 9,
		
		sprite = "17fcd0f1064.png",
		
		xSeparation = 2,
		ySperation = 4,
		
		xStart = 245,
		yStart = 209,
		
		xOffset = 0,
		yOffset = 2
	},
	
	["playerCraft"] = {
		size = 32,
		lines = 2,
		collumns = 2,
		
		sprite = "17fcd1000b4.png",
		
		xSeparation = 2,
		ySeparation = 2,
		
		xStart = 415,
		yStart = 88,
		
		xOffset = 0,
		yOffset = 0,
		
		output = 5,
		
		callback = function(self, playerObject)
			local item, itemList = stackFetchCraft(playerObject.inventory.craft, 4)
			local _i = playerObject.inventory.craft
			if item and itemList then
				return itemCreate(_i.slot[#_i.slot], item[1], item[2], true), itemList
			end
		end,
		
		slot = {
			[5] = {
				dx = 524,
				dy = 104,
				--callback = dummyFunc,
				insert = false
			}
		}
	},
	
	["Crafting Table"] = {
		size = 32,
		lines = 3,
		collumns = 3,
		
		sprite = "17fcd0f8b01.png",
		
		xSeparation = 2,
		ySeparation = 2,
		
		xStart = 302,
		yStart = 84,
		
		xOffset = 0,
		yOffset = 0,
		
		callback = function(self, playerObject, blockObject)
			local _i = blockObject.handle[playerObject.name] or blockObject.handle
			local item, itemList = stackFetchCraft(_i, 9)

			if item and itemList then
				return itemCreate(_i.slot[#_i.slot], item[1], item[2], true), itemList
			end
		end,
		
		output = 10,
		slot = {
			[10] = {
				dx = 458,
				dy = 113,
				--callback = dummyFunc,
				size = 48,
				insert = false
			}
		}
	},
	
	["playerArmor"] = {
		size = 32,
		lines = 4,
		collumns = 1,
		
		sprite = "17fcd0dfffa.png",
		
		ySeparation = 2,
		
		xStart = 250,
		yStart = 60,
		
		xOffset = 1,
	
		callback = dummyFunc,
		
		slot = {
			[5] = {
				dx = 374,
				dy = 163
			}
		}
	},
	["playerInvBar"] = {
		size = 32,
		lines = 1,
		collumns = 9,
		
		sprite = "17e464e9c5d.png",
		
		xSeparation = 2,
		
		xStart = 245,
		yStart = 352,
		
		yOffset = 3,
		
		callback = dummyFunc
	}
}

objectMetadata = {
--[[
[] = {
		name = "",
		drop = ,
		durability = ,
		glow = ,
		translucent = ,
		sprite = "",
		particles = {}
	},
]]
	-- ==========		DIRT		========== --
	[1] = {
		name = "Dirt",
		drop = 1,
		durability = 14,
		glow = 0,
		translucent = false,
		sprite = "17dd4af277b.png",
		interact = false,
		particles = {21, 24, 44},
		onAwait = function(self, Player, tl)
			if self.timestamp == tl and self.type == 1 then
				blockCreate(self, 2, self.ghost, true, Player)
			end
		end,
		onUpdate = function(self, Player)
			local block = getPosBlock(self.dx + 16, self.dy - 216)
			if block.type == 0 then
				self.event = appendEvent(
					math.random(7000, 10000), 
					self.onAwait, 
					self, Player, (self.timestamp)
				)
			end
		end,
		onDestroy = function(self, Player)
			if self.event then
				removeEvent(self.event)
				self.event = nil
			end
		end,
		onPlacement = function(self, Player)
			self:onUpdate(Player)
		end
	},
	[2] = {
		name = "Grass",
		drop = 1,
		durability = 14,
		glow = 0,
		translucent = false,
		sprite = "17dd4b0a359.png",
		interact = false,
		particles = {21, 22, 44},
		onAwait = function(self, Player, tl)
			if self.timestamp == tl and self.type == 2 then
				blockCreate(self, 1, self.ghost, true, Player)
			end
		end,
		onUpdate = function(self, Player)
			local block = getPosBlock(self.dx + 16, self.dy - 216)
			if block.type ~= 0 then
				self.event = appendEvent(
					math.random(3000, 5000),
					self.onAwait,
					self, Player, (self.timestamp)
				)
			end
		end,
		onDestroy = function(self, Player)
			if self.event then
				removeEvent(self.event)
				self.event = nil
			end
		end
	},
	[3] = {
		name = "Snowed Dirt",
		drop = 1,
		durability = 14,
		glow = 0,
		translucent = false,
		sprite = "17dd4aedb5d.png",
		interact = false,
		particles = {4, 21, 44, 45}
	},
	[4] = {
		name = "Snow",
		drop = 4,
		durability = 8,
		glow = 0,
		translucent = false,
		sprite = "17dd4b5fb5d.png",
		interact = false,
		particles = {4, 45}
	},
	[5] = {
		name = "Dirtcelium",
		drop = 1,
		durability = 16,
		glow = 0,
		translucent = false,
		sprite = "17dd4ae8f5b.png",
		interact = false,
		particles = {21, 21, 32, 43}
	},
	[6] = {
		name = "Mycelium",
		drop = 6,
		durability = 16,
		glow = 0,
		translucent = false,
		sprite = "17dd4b1875c.png",
		interact = false,
		particles = {43}
	},
	-- ==========		STONE		========== --
	[10] = {
		name = "Stone",
		drop = 19,
		durability = 34,
		glow = 0,
		translucent = false,
		sprite = "17dd4b6935c.png",
		interact = false,
		particles = {3, 4}
	},
	[11] = {
		name = "Coal Ore",
		drop = 11,
		durability = 42,
		glow = 0,
		translucent = false,
		sprite = "17dd4b26b5d.png",
		interact = false,
		particles = {3, 4}
	},
	[12] = {
		name = "Iron Ore",
		drop = 12,
		durability = 46,
		glow = 0.2,
		translucent = false,
		sprite = "17dd4b39b5c.png",
		interact = false,
		particles = {3, 2, 1}
	},
	[13] = {
		name = "Gold Ore",
		drop = 13,
		durability = 46,
		glow = 0.4,
		translucent = false,
		sprite = "17dd4b34f5a.png",
		interact = false,
		particles = {2, 3, 11, 24}
	},
	[14] = {
		name = "Diamond Ore",
		drop = 14,
		durability = 52,
		glow = 0.8,
		translucent = false,
		sprite = "17dd4b2b75d.png",
		interact = false,
		particles = {3, 1, 9, 23} 
	},
	[15] = {
		name = "Emerald Ore",
		drop = 15,
		durability = 52,
		glow = 0.7,
		translucent = false,
		sprite = "17dd4b3035f.png",
		interact = false,
		particles = {3, 11, 22}
	},
	[16] = {
		name = "Lazuli Ore",
		drop = 16,
		durability = 34,
		glow = 0.3,
		translucent = false,
		sprite = "17e46514c5d.png",
		interact = false,
		particles = {}
	},
	[19] = {
		name = "Cobblestone",
		drop = 19,
		durability = 26,
		glow = 0,
		translucent = false,
		sprite = "17dd4adf75b.png",
		interact = false,
		particles = {3}
	},
	-- ==========		SAND		========== --
	[20] = {
		name = "Sand",
		drop = 20,
		durability = 10,
		glow = 0,
		translucent = false,
		sprite = "17dd4b5635b.png",
		interact = false,
		particles = {24}
	},
	[21] = {
		name = "Sandstone",
		drop = 21,
		durability = 26,
		glow = 0,
		translucent = false,
		sprite = "17dd4b5af5c.png",
		interact = false,
		particles = {3, 24, 24}
	},
	[25] = {
		name = "Cactus",
		drop = 25,
		durability = 10,
		glow = 0,
		translucent = false,
		sprite = "17e4651985c.png",
		interact = false,
		particles = {}
	},
	-- ==========		UTILITIES		========== --
	[50] = {
		name = "Crafting Table",
		drop = 50,
		durability = 24,
		glow = 0,
		translucent = false,
		sprite = "17dd4ae435c.png",
		interact = true,
		particles = {1},
		handle = {
			stackNew, 10, "Crafting Table",
			stackPresets["Crafting Table"],
			0, "Crafting Table"
		},
		onInteract = function(self, playerObject)
			playerObject.inventory.bridge = blockGetInventory(self)
			
            playerHideInventory(playerObject)
            playerDisplayInventory(
                playerObject,
                {{"bag", 0, 0, true}, 
                {"invbar", 0, -36, false}, 
                {"bridge", 0, 0, true}}
            )
		end
	},
	[51] = {
		name = "Oven",
		drop = 51,
		durability = 40,
		glow = 0,
		translucent = false,
		sprite = "17dd4b4335d.png",
		interact = true,
		particles = {3, 1}
	},
	[52] = {
		name = "Oven",
		drop = 51,
		durability = 40,
		glow = 2,
		translucent = false,
		sprite = "17dd4b3e75b.png",
		interact = true,
		particles = {3, 1}
	},
	
	[70] = {
		name = "Wood",
		drop = 70,
		durability = 24,
		glow = 0,
		translucent = false,
		sprite = "17e46510078.png",
		interact = false,
		particles = {}
	},
	[73] = {
		name = "Jungle Trunk",
		drop = 73,
		durability = 24,
		glow = 0,
		translucent = false,
		sprite = "17e4651e45d.png",
		interact = false,
		particles = {},
		onDestroy = defTrunkDestroy
	},
	[74] = {
		name = "Jungle Leaves",
		drop = 74,
		durability = 4,
		glow = 0,
		translucent = false,
		sprite = "17e4652c85c.png",
		interact = false,
		particles = {}
	},
	[75] = {
		name = "Fir Trunk",
		drop = 75,
		durability = 24,
		glow = 0,
		translucent = false,
		sprite = "17e46527c5e.png",
		interact = false,
		particles = {},
		onDestroy = defTrunkDestroy
	},
	[76] = {
		name = "Fir Leaves",
		drop = 76,
		durability = 4,
		glow = 0,
		translucent = false,
		sprite = "17e46501bd8.png",
		interact = false,
		particles = {}
	},
	[80] = {
		name = "Pumpkin",
		drop = 80,
		durability = 24,
		glow = 0,
		translucent = false,
		sprite = "17dd4b5175b.png",
		interact = false,
		particles = {}
	},
	[81] = {
		name = "Pumpkin Mask",
		drop = 81,
		durability = 20,
		glow = 0,
		translucent = false ,
		sprite = "17dd4b4cb5c.png",
		interact = true,
		particles = {}
	},
	[82] = {
		name = "Pumpkin Torch",
		drop = 82,
		durability = 24,
		glow = 3.5,
		translucent = 0,
		sprite = " 17dd4b47f5a.png",
		interact = true,
		particles = {}
	},
	[100] = {
		name = "Ice",
		drop = 0,
		durability = 6,
		glow = 0,
		translucent = true,
		sprite = "x0xKxfi",
		interact = false,
		particles = {}
	},
	[108] = {
		name = "Crystal",
		drop = 0,
		durability = 6,
		translucent = true,
		sprite = "17e4652305d.png",
		interact = false,
		particles = {}
	},
	-- ==========		NETHER		========== --
	[130] = {
		name = "Netherrack",
		drop = 130,
		durability = 26,
		glow = 0,
		translucent = false,
		sprite = "17dd4b1d35c.png",
		interact = false,
		particles = {43, 44}
	},
	[139] = {
		name = "Soulsand",
		drop = 29,
		durability = 20,
		glow = 0,
		translucent = false,
		sprite = "17dd4b6475d.png",
		interact = false,
		particles = {3, 43}
	},
	-- ==========		END		========== --
	[170] = {
		name = "Endstone",
		drop = 170,
		durability = 26,
		glow = 0,
		translucent = false,
		sprite = "17dd4b00b5b.png",
		interact = false,
		particles = {24, 32}
	},
	[178] = {
		name = "End Portal",
		drop = 178,
		durability = 52,
		glow = 0,
		translucent = true,
		sprite = "17dd4afbf5b.png",
		interact = true,
		particles = {3, 22, 23, 34}
	},
	[179] = {
		name = "End Portal (activated)",
		drop = 178,
		durability = 52,
		glow = 0.7,
		translucent = true,
		sprite = "17dd4af735a.png",
		interact = true,
		particles = {3, 22, 23, 34}
	},

    [192] = {
        name = "TNT",
        drop = 192,
        durability = 18,
        glow = 0,
        translucent = false,
        sprite = "17ff03debf2.png",
        interact = true,
        particles = {},
        onInteract = function(self, ...)
            appendEvent(3000, self.onAwait, self, ...)
        end,
        onAwait = function(self, playerObject)
            worldExplosion(self.dx+16, self.dy+16, 3, 1.25, playerObject)
            blockDestroy(self, true, playerObject)
        end
    },
	-- ==========		MISC		========== --
	[256] = {
		name = "Bedrock",
		drop = 256,
		durability = -1,
		glow = 0,
		translucent = false,
		sprite = "17dd4adaaf0.png",
		interact = false,
		particles = {3, 3, 3, 4, 4, 36}
	}
	
	
	-- ===========================		 NON BLOCKS 		=========================== --
	
	
}

xpcall(main, errorHandler)

-- 09/04/2022 11:05:36 --