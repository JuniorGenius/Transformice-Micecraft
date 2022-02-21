local modulo = {
	creator = "Indexinel#5948",
	name = "Micecraft",
	loading = nil,
	sprite = "15150c10e92.png"
}

game = function()

local math = math
local os = os
local string = string
local table = table

local system = system
local tfm = tfm
local ui = ui


ui.addTextArea(999 , "<font size='64'><p align='center'>Initializing...</p></font>", nil, 100, 150, 600, 200, 0x000000, 0x000000, 1.0, true)
modulo.loading = tfm.exec.addImage(modulo.sprite, ":999", 0, 0, nil, 1.0, 1.0, 0, 1.0, 0, 0)

local chunkSize = 12
local maxBounds = {height=256, width=1020}
local globalGrounds = 0

local timer = 0
local awaitTime = 3000

local xmlLoad = '<C><P Ca="" H="8392" L="32640" /><Z><S></S><D><DS X="%d" Y="%d" /></D><O /></Z></C>'
-- aie=""
-- Ca=""


local room = {
	totalPlayers = 0,
	isTribe = (string.sub(tfm.get.room.name, 1, 2) == "*\003"),
	runtimeMax = 0,
	player = {}
}

room.runtimeMax = (room.isTribe and 40 or 60)

local map = {
	size = {
		height = maxBounds.height,
		width = maxBounds.width
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
	
	runtimeLapse = 0,
	timestamp = 0,
	
	structures = {}
	--[[sun = {
		x = 16320,
		y = 200,---5000,
		glow = 1024--2000
	}]]
}

-- =============	  RESOURCES 	============== --

local structureData = {
	[1] = {
		{{0},{72,true,-1,7},{72,false,0,7},{72,true,1,7},{0}},
		{{0},{72,false,-1,6},{72,false,0,6},{72,false,1,6},{0}},
		{{72,false,-2,5},{72,false,-1,5},{72,false,0,5},{72,false,1,5},{72,false,2,5}},
		{{72,false,-2,4},{72,false,-1,4},{72,false,0,4},{72,false,1,4},{72,false,2,4}},
		{{0},{0},{71,false,0,3},{0},{0}},
		{{0},{0},{71,false,0,2},{0},{0}},
		{{0},{0},{71,false,0,1},{0},{0}}
	}
}

local shadowSprite = "17e2d5113f3.png"

--[[
biomas:
overworld
frost
desert
nether
end
]]

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

local blockMetadata = {
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
		particles = {21, 24, 44}
	},
	[2] = {
		name = "Grass",
		drop = 1,
		durability = 14,
		glow = 0,
		translucent = false,
		sprite = "17dd4b0a359.png",
		interact = false,
		particles = {21, 22, 44}
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
		particles = {1}
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
		sprite = nil,
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
		particles = {}
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
		particles = {}
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
}

local damageSprites = {"17dd4b6df60.png", "17dd4b72b5d.png", "17dd4b7775d.png", "17dd4b7c35f.png", "17dd4b80f5e.png", "17dd4b85b5f.png", "17dd4b8a75e.png", "17dd4b8f35f.png", "17dd4b93f5e.png", "17dd4b98b5d.png"}
local mossSprites = {"17dd4b9d75e.png", "17dd4bb075d.png", "17dd4ba235f.png", "17dd4babb5c.png", "17dd4ba6f77.png"}

local cmyk = {{"17e13158459.png", 0}, {"17e13161c88.png", 0}, {"17e1316685d.png", 0}, {"17e1315d05f.png", 0}}

-- =============	  OPTIMIZATION 	============== --


-- =============	  UTILITIES 	============== --

local _math_round = function(number, precision)
	local _mul = 10^precision
	return math.floor(number*_mul) / _mul
end

local _table_extract = function(t, e)
	for i in next, t do
		if t[i] == e then
			return table.remove(t, i)
		end
	end
end

local distance = function(ax, ay, bx, by)
	return math.sqrt((bx-ax)^2 + (by-ay)^2)
end

local varify = function(args, pattern)
	local t = {}
	args:gsub(" ", "")
	for arg in args:gmatch(pattern or "(%d+)?%p") do
		table.insert(t, arg)
	end
	return table.unpack(t)
end

local RGBtoCMYK = function(r, g, b)	
	r=r/255
	g=g/255
	b=b/255
	local k = 1-math.max(r,g,b)
	local v = function(n) return (1-n-k)/(1-k) end
	
	return v(r), v(g), v(b), k
end

local HSLtoRGB = function(h, s, l)
	s = s/100
	l = l/100

	local k = function(n) return ((n + h)/30)%12 end
	local a = s*math.min(l, 1-l)
	local f = function(n) return (l-a)*math.max(-1, math.min(k(n)-3, math.min(9-k(n), 1))) end

	return 255*f(0), 255*f(8), 255*f(4)
end

local RGBtoHSL = function(r, g, b)
	r = r/255
	g = g/255
	b = b/255
	
	local l = math.max(r,g,b)
	local s = l-math.min(r,g,b)
	local h = s and (l==r and (g-b)/s or (l==g and 2+(b-r)/s or 4+(r-g)/s)) or 0
	
	return h < 0 and 60*h+360 or 60*h, 100*(s and (l<=0.5 and s/(2*l-s) or s/(2-(2*l-s)))) or 0, (100*(2*l-s))/2
end

local toBase = function(n, b)
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

local RGBtoHEX = function(r, g, b)
	return ("%06x"):format(tonumber(bit32.lshift(r, 16) + bit32.lshift(g, 8)+ b, 16))
end

local HEXtoRGB = function(hex)
	if type(hex) == "string" then
		hex:gsub("#", "0x")
		hex = tonumber(hex, 16)
	end
	return bit32.band(bit32.rshift(hex, 16), 255), bit32.band(bit32.rshift(hex, 8), 255), bit32.band(hex, 255)
end

local linearInterpolation = function(r1, g1, b1, r2, g2, b2, sep, e)
	local ar = (r2-b1)/sep
	local ag = (g2-b1)/sep
	local ab = (b2-b1)/sep

	return (ar*e)+r1, (ag*e)+g1, (ab*e)+b1
end

local cosineInterpolate = function(a, b, x)
	local f = (1-math.cos(x*math.pi))*0.5
	return (a*(1-f)) + (b*f)
end

local generatePerlinHeightMap = function(seed, amplitude, waveLength, surfaceStart, width, heightMid)
	if seed then math.randomseed(seed) end
	
	local heightMap = {}
	local amp = amplitude or 30 -- 172
	local wl = waveLength or 24 -- 64
	local x, y = 0, surfaceStart or 128 -- 1, 128
	local hval = heightMid or 128
	local a, b = math.random(), math.random()
	
	while x < width do
		if x%wl == 0 then
			a = b
			b = math.random()
			y = hval + (a*amp)
		else
			y = hval + (cosineInterpolate(a, b, (x%wl)/wl) * amp)
		end
		
		heightMap[x+1] = math.floor(y+0.5) or 1
		
		x = x + 1
	end

	return heightMap
end

local getPosChunk = function(x, y, passObject)
	if x < 0 then x = 1 
	elseif x > 32640 then x = 32639 end
	if y < 0 then y = 1
	elseif y > 8192 then y = 8191 end
	
	local yc = 85*math.floor((y/32)/32)
	local xc = math.floor((x/32)/12)
	local eq = yc + xc + 1
	return passObject and map.chunk[eq] or eq
end

local getPosBlock = function(x, y)
	if x < 0 then x = 1 
	elseif x > 32640 then x = 32639 end
	if y < 0 then y = 1
	elseif y > 8192 then y = 8191 end

	local chunk = getPosChunk(x, y)
	return map.chunk[chunk].block[1+(math.floor(y/32)%32)][1+(math.floor(x/32)%12)]
end

local ui_changeBackgroundColor = function(color)
	local r, g, b
	local c, m, y, k
	local t = type(color)
	if t == "table" then
		if color.k then
			c = color.c
			m = color.m
			y = color.y
			k = color.k
		else
			r = color.r
			g = color.g
			b = color.b
		end
	elseif t == "string" or t == "number" then
		r, g, b = HEXtoRGB(color)
	end
	
	if not r then r = 255 end
	if not g then g = 255 end
	if not b then b = 255 end
	
	if not k then
		c, m, y, k = RGBtoCMYK(r, g, b)
	end
	t = {c, m, y, k}
	
	for i=1, 4 do
		if cmyk[i][2] then tfm.exec.removeImage(cmyk[i][2]) end
		cmyk[i][2] = tfm.exec.addImage(cmyk[i][1], "?1", 0, 0, nil, _, _, _, t[i])
	end
end

local bgData = {}

local getTruePosMatrix = function(chunk, x, y)
	return (((chunk-1)%85)*12)+(x-1), (math.floor((chunk-1)/85)*32)+(y-1)
end

-- =============	  MADE FUNCTIONS 	============== --

local _tfm_exec_addPhysicObject = tfm.exec.addPhysicObject
local addPhysicObject = function(id, x, y, bodydef)
	_tfm_exec_addPhysicObject(id, x, y, bodydef)
	globalGrounds = globalGrounds + 1
end

local _tfm_exec_removePhysicObject = tfm.exec.removePhysicObject
local removePhysicObject = function(id)
	_tfm_exec_removePhysicObject(id)
	globalGrounds = globalGrounds - 1
end

-- ============= 		BLOCKS		============== -- 

local spreadParticles = function(particles, amount, kind, xor, yor)
	local particles = (type(particles) == "number" and {particles} or particles)
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

local getBlocksAround = function(self, include, cross)
	local condition
	local blockList = {}
	
	local _table_insert, _getPosBlock = table.insert, getPosBlock
	
	for i=-1, 1 do
		for j=-1, 1 do
			condition = (not cross and (true) or (j==0 or i==0))
			if ((not (i==0 and j==0)) or include) and condition then
				_table_insert(blockList, _getPosBlock((self.dx+16) + (32*j), (self.dy-184) + (32*i)))
			end
		end
	end
	
	return blockList
end

local blockNew = function(x, y, type, damage, ghost, glow, translucent, mossy, chunk, surfacePoint)
	local xp, yp = getTruePosMatrix(chunk, x, y)
	yp = 256-yp
	
	local block = {
		x = xp,
		y = yp,
		rx = x,
		ry = y,
		id = ((x-1)*32) + y,
		gid = (((chunk-1)*384)+((x-1)*32)+y),
		act = (type == 0 or ghost) and 0 or -1,
		dx = xp*32,
		dy = ((256-yp)*32)+200,
		alpha = 1.0,
		type = type,
		damage = damage or 0,
		damagePhase = 0,
		shadowness = (ghost and not translucent) and 0.33 or 0,
		sprite = {},
		ghost = ghost or false,
		glow = glow or false,
		translucent = translucent or false,
		mossy = mossy or false,
		interact = type ~= 0 and blockMetadata[type].interact or false,
		chunk = chunk
	}
	
	--[[if type ~= 0 then
		local chunkk = map.chunk[chunk]
		block.shadowness = (distance(0, yp, 0, surfacePoint)/8)*0.67--128
		if block.shadowness > 0.67 then block.shadowness = 0.67 end
	end]]
	block.sprite = {
		[1] = {
			block.type >= 1 and blockMetadata[block.type].sprite or nil,
			block.type >= 1 and mossSprites[--[[map.chunk[chunk].biome]]1] or nil,
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
		local __tfm_exec_addImage = tfm.exec.addImage
		self.sprite[2] = {
			_tfm_exec_addImage(self.sprite[1][1], "_1", self.dx, self.dy, nil, 1.0, 1.0, 0, self.alpha, 0, 0),
			self.mossy and _tfm_exec_addImage(self.sprite[1][2], "_2", self.dx, self.dy, nil, 1.0, 1.0, 0, self.alpha, 0, 0) or nil,
			self.translucent and nil or _tfm_exec_addImage(self.sprite[1][3], "_3", self.dx, self.dy, nil, 1.0, 1.0, 0, self.shadowness*self.alpha, 0, 0),
			self.damage > 0 and _tfm_exec_addImage(self.sprite[1][4], "_4", self.dx, self.dy, nil, 1.0, 1.0, 0, self.alpha, 0, 0) or nil
		}
	end
end

local blockHide = function(self)
	if self.type > 0 then
		local _tfm_exec_removeImage = tfm.exec.removeImage
		for k=1, 4 do
			if self.sprite[2][k] then 
				_tfm_exec_removeImage(self.sprite[2][k])
				self.sprite[2][k] = nil
			end
		end
	end
end

local getMidPoints = function(points, separation, toNearestInt)
	local _math_floor = math.floor
	local limit = #points - 1
	local tab = {}
	local rad = _math_floor((separation/limit)+0.5)
	
	for i=1, limit do
		local ap = points[i]
		local bp = points[i+1]
		local se = (bp-ap)/rad
		for j=0, rad-1 do
			local index = (((i-1)*rad)+1)+j
			if index <= separation then
				tab[index] = toNearestInt and _math_floor((ap+(j*se))+0.5) or ap+(j*se)
			else
				break
			end
		end
	end
	
	return tab
end

-- ============= 		CHUNKS		============== -- 

local chunkCalculateCollisions
local structureCreate

local chunkNew = function(id, loaded, activated, biome, heightMaps)
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
		ioff = ((id-1)*384),---1,
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
						if _math_random(20) == 1 then type = _math_random(11, 16) end
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

local chunkLoad = function(self)
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
    until matches <= 0
	
	return segments
end

local chunkActivateSegment = function(self, seg)
	local obj = self.grounds[1][seg]
	if obj then
		addPhysicObject(obj.id, obj.xPos, obj.yPos, obj.bodydef)
		self.grounds[2][seg] = obj.id
	end
end

local chunkActivateSegRange = function(self, segList)
	for i in next, segList do
		chunkActivateSegment(self, segList[i])
	end
end

local chunkDeactivateSegment = function(self, seg)
	if seg > 0 then
		if self.grounds[2][seg] then
			removePhysicObject(self.grounds[2][seg])
		end
		self.grounds[2][seg] = nil
	end
end

local chunkDeleteSegment = function(self, seg)
	if seg > 0 then
		if self.grounds[1][seg] then
			local block
			_table_extract(self.segments, seg)
			for y=self.grounds[1][seg].startPoint[2], self.grounds[1][seg].endPoint[2] do
				for x=self.grounds[1][seg].startPoint[1], self.grounds[1][seg].endPoint[1] do
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

local chunkRefreshSegment = function(self, seg)
	chunkDeactivateSegment(self, seg)
	chunkDeleteSegment(self, seg)
	local actList = chunkCalculateCollisions(self)
	chunkActivateSegRange(self, actList)
end

local chunkRefreshSegList = function(self, blockList)
	local block
	
	for i in next, blockList do
		block = blockList[i]
		
		if block.chunk == self.id then
			chunkDeactivateSegment(self, block.act)
			chunkDeleteSegment(self, block.act)
		end
	end

	local actList = chunkCalculateCollisions(self)
	chunkActivateSegRange(self, actList)
end

local chunkActivate = function(self, onlyPhysics) 
	if not self.activated then
		if self.timestamp < os.time() - 4000 then
			
			for g in next, self.segments do
				if self.grounds[1][self.segments[g]] then
					chunkActivateSegment(self, self.segments[g])
				end
			end
		
			if not self.loaded and not onlyPhysics then chunkLoad(self) end
			self.activated = true
			self.timestamp = os.time()
		end
	end
end

local chunkDeactivate = function(self)
	if self.activated then
		if self.timestamp < os.time() - 4000 then
			for g in next, self.segments do
				if self.grounds[1][self.segments[g]] then
					chunkDeactivateSegment(self, self.segments[g])
				end
			end

			self.activated = false
		end
	end
end

local chunkDelete = function(self)
	for g in next, self.segments do
		chunkDeleteSegment(self, self.segments[g])
	end
end

local chunkUnload = function(self, onlyVisual)
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
end

local chunkReload = function(self)
	chunkUnload(self, true)
	chunkLoad(self)
end

local chunkRefresh = function(self, update)
	chunkDeactivate(self)
	if update then chunkCalculateCollisions(self) end
	chunkActivate(self, true)
end

local chunkFlush = function(self)
	chunkUnload(self)
	chunkActivate(self)
end

local chunkUpdate = function(self, onlyPhysic, onlyVisual)
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

local worldRefreshChunks = function()
	local _chunkDeactivate, chunkList = chunkDeactivate, map.chunk
	for i=1, 680 do
		_chunkDeactivate(chunkList[i])
	end

	for _, player in next, room.player do
		player.timestamp = os.time()
	end
end

local handleChunksRefreshing = function()
	local _os_time = os.time

	local peak = room.runtimeMax - 8
	local counter = map.runtimeLapse
	local lapse = 0
	local dif = _os_time()
	
	local handle = map.handle
	local chunkList = map.chunk
	local chunks = #chunkList
	
	local i, calls = 1, 0
	
	local ok, res
	
	while i <= chunks do
		if counter < peak then
			
			if handle[i] then
				lapse = _os_time()
				ok, res = pcall(handle[i][2], chunkList[handle[i][1]])
				if ok then
					handle[i] = nil
					calls = calls + 1
				else
					error(res)
					--[[
					
					if handle[i][2] == chunkUnload then
						error("Issue on chunkUnload.")
					else
						handle[i][2] = chunkUnload
						i = i - 1
					end]]
				end
				counter = counter + (_os_time() - lapse)
			end
			
		else
			print("/!\\")
			map.timestamp = _os_time()
			break
		end
		
		i = i + 1
	end
	
	return calls, _os_time() - dif
end

local recalculateShadows = function(origin, range)
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

-- ============= 		BLOCKS		============== -- 

local blockDestroy = function(self, display)
	if self.type ~= 256 then
		if display then blockHide(self) end
		if self.ghost then
			self.type = 0
		elseif not self.ghost then
			local meta = blockMetadata[self.type]
			self.ghost = true
			self.alpha = 1.0
			self.shadowness = 0.33
			self.damage = 0
			--spreadParticles(meta.particles, 7, "drop", {self.dx+8, self.dx+24}, {self.dy+8, self.dy+24})
			if display then blockDisplay(self) end
		end
		--self.act = 0
		chunkRefreshSegList(map.chunk[self.chunk], getBlocksAround(self, true))
	end
end

local blockCreate = function(self, type, ghost, display)
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
		--chunkRefresh(map.chunk[self.chunk], true)
		end
	end
end

local blockDamage = function(self, amount)
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

-- =============== 		INVENTORY		============== --

local playerGetInventorySlot

local itemNew = function(id, itemId, stackable, amount, interact)
	local self = {
		id = id,
		itemId = itemId or 0,
		stackable = stackable or true,
		amount = amount or 0,
		sprite = {},
		dx = interact and {} or 245+(34*((id-1)%9))+10,
		dy = interact and {} or 209+(34*(math.floor((id-1)/9))) + (id > 27 and 16 or 10)
	}
	
	if interact then
		self.dx = {
			craft = {
				[4] = 245 + (id <= 104 and 170 + (34*((id-101)%2)) or 277),
				[9] = 245 + (id <= 109 and 57 + (34*((id-101)%3)) or 213)
			},
			furnace = 245 + (id <= 102 and 99 or 196 + 3)
		}
		self.dy = {
			craft = {
				[4] = 42 + (id <= 104 and 46 + (34*math.floor((id-101)/2)) or 62),
				[9] = 42 + (id <= 109 and 42 + (34*math.floor((id-101)/3)) or 71)
			},
			furnace = 42 + (id <= 102 and 36 + (id == 2 and 68 or 0) or 65 + 3)
		}
	end
	
	return self
end

local itemCreate = function(self, itemId, amount, stackable)
	self.itemId = itemId
	self.amount = amount or 1
	self.stackable = stackable or true
	self.sprite[1] = itemId ~= 0 and blockMetadata[itemId].sprite or nil
	
	return self
end

local itemRemove = function(self, playerName)
	local item = self
	
	self.itemId = 0
	self.amount = 0
	self.stackable = false
	
	if self.sprite[2] then tfm.exec.removeImage(self.sprite[2]) end
	self.sprite[1] = nil
	self.sprite[2] = nil
	
	ui.removeTextArea(self.id+60, playerName)
	--ui.removeTextArea(self.id+110, playerName)
	
	return item
end

local itemAdd = function(self, amount)
	if self.itemId ~= 0 then
		if self.stackable then
			local fixedAmount = self.amount + amount
			self.amount = fixedAmount > 64 and 64 or fixedAmount
			return fixedAmount > 64 and fixedAmount - 64 or amount
		end
	end
	
	return false
end

local itemSubstract = function(self, amount)
	if self.itemId ~= 0 then
		if self.stackable then
			local fixedAmount = self.amount - amount
			self.amount = fixedAmount < 0 and 0 or fixedAmount
			return fixedAmount < 0 and 0 or amount 
		end
	end
end

local itemReturnDisplayPositions = function(self, playerName)
	local player = room.player[playerName]
	local dx, dy
	
	if type(self.dx) == "number" then
		dx = self.dx
	else
		if player.inventory.interaction.crafting then
			dx = self.dx.craft[player.inventory.interaction.crafting]
		elseif player.inventory.interaction.furnacing then
			dx = self.dx.furnace
		end
	end
	
	if type(self.dy) == "number" then
		dy = self.dy
	else
		if player.inventory.interaction.crafting then
			dy = self.dy.craft[player.inventory.interaction.crafting]
		elseif player.inventory.interaction.furnacing then
			dy = self.dy.furnace
		end
	end
	
	return dx, dy
end

local itemDisplay = function(self, playerName, onInventoryBar)
	if self.sprite[2] then tfm.exec.removeImage(self.sprite[2]) end
	
	local dx, dy = itemReturnDisplayPositions(self, playerName)
	local scale = (self.id == 110 and (room.player[playerName].inventory.interaction.crafting == 9 and 1.5 or 1.0) or 1.0)
	dy = dy + (onInventoryBar and 34 or 0)--(self.id == 110 and -34 or 0))
	local _ui_addTextArea, _ui_removeTextArea = ui.addTextArea, ui.removeTextArea
	
	if self.itemId ~= 0 then
		self.sprite[2] = tfm.exec.addImage(
			self.sprite[1],
			":"..(self.id+10),
			dx, dy,
			playerName,
			scale/1.8823, scale/1.8823,
			0, 1.0,
			0, 0
		)
		
		if self.stackable then
			_ui_addTextArea(
				self.id+60,
				string.format("<p align='center'><font size='"..(13*scale).."'><VP><b>%d", self.amount),
				playerName,
				dx-(9*scale), dy,
				34*scale, 0,
				0x000000, 0x000000,
				1.0, true
			)
		else
			_ui_removeTextArea(self.id+60, playerName)
		end
	else
		self.sprite[2] = nil
		_ui_removeTextArea(self.id+60, playerName)
	end
	
	_ui_addTextArea(
		self.id+110,
		"<textformat leftmargin='1' rightmargin='1'><a href='event:"..(self.id > 100 and "interaction" or "inventory").."'>\n\n\n\n\n\n\n\n\n\n\n\n", 
		playerName, 
		dx - (10*scale), dy - (10*scale), --350
		37*scale, 32*scale, 
		0x000001, 0x000001, 
		0, true
	)
	
	return {dx, dy}
end

local itemHide = function(self, playerName)
	if self.sprite[2] then tfm.exec.removeImage(self.sprite[2]) end
	self.sprite[2] = nil
	
	ui.removeTextArea(self.id+60, playerName)
	ui.removeTextArea(self.id+110, playerName)
end

local stackFindItem = function(self, itemId, canStack)
	for i in next, self do
		if self[i].itemId == itemId then
			if canStack then
				if self[i].stackable and self[i].amount < 64 then
					return self[i]
				end
			else
				return self[i]
			end
		end
	end

	return nil
end

local inventoryFindItem = function(self, itemId, canStack, onInteraction)
	local stack = (onInteraction and self.interaction or self.slot)
	
	return stackFindItem(stack, itemId, canStack)
end

local inventoryCreateItem = function(self, itemId, amount, targetSlot)
	local slot = targetSlot or inventoryFindItem(self, 0)

	if slot then
		return itemCreate(slot, itemId, amount, (amount > 0))
	end
	
	return nil
end

local inventoryInsertItem = function(self, itemId, amount, targetSlot, interaction)
	local item = inventoryFindItem(self, itemId, true, false)
	
	if targetSlot then
		if type(targetSlot) == "boolean" then
			item = playerGetInventorySlot(room.player[self.owner], self.selectedSlot)
		elseif type(targetSlot) == "number" then
			item = playerGetInventorySlot(room.player[self.owner], targetSlot)
		elseif type(targetSlot) == "table" then
			item = targetSlot
		end
		
		if item.itemId ~= 0 then
			if (item.stackable and item.amount + amount > 64) or item.itemId ~= itemId then
				item = inventoryFindItem(self, itemId, true, interaction)
			end
		--[[else
			item = inventoryFindItem(self, itemId, true)]]
		end
	end
	
	if item then
		if item.stackable and item.amount + amount <= 64 and item.itemId == itemId then
			itemAdd(item, amount)
			return item
		else
			return inventoryCreateItem(self, itemId, amount, item)
		end
	else
		return inventoryCreateItem(self, itemId, amount, item)
	end
	
	return item
end

local inventoryExtractItem = function(self, itemId, amount, targetSlot)
	local item = inventoryFindItem(self, itemId)
	
	if targetSlot then
		if type(targetSlot) == "boolean" then
			item = playerGetInventorySlot(room.player[self.owner], self.selectedSlot)
		elseif type(targetSlot) == "number" then
			item = playerGetInventorySlot(room.player[self.owner], targetSlot)
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
				return itemSubstract(item, amount)
			end
		else
			return itemRemove(item, self.owner)
		end
	end
	
	return item
end

local inventoryExchangeItemsPosition = function(item1, item2)
	local exchange = {
		itemId = item1.itemId,
		stackable = item1.stackable,
		amount = item1.amount,
		sprite = item1.sprite
	}
	
	item1.itemId = item2.itemId
	item1.stackable = item2.stackable
	item1.amount = item2.amount
	item1.sprite = item2.sprite
	
	item2.itemId = exchange.itemId
	item2.stackable = exchange.stackable
	item2.amount = exchange.amount
	item2.sprite = exchange.sprite
end

local itemMove = function(self, direction, amount, playerName)
	local targetPlayer = playerName
	local sourcePlayer = playerName
	
	if type(playerName) == "table" then
		targetPlayer = playerName[2]
		sourcePlayer = playerName[1]
	end
	
	local newSlot = room.player[sourcePlayer].inventory.selectedSlot
	
	if self and direction then 
		local moveCondition = (targetPlayer ~= sourcePlayer and (direction.id < 100) or (self.id ~= direction.id))
		if moveCondition then
			newSlot = (targetPlayer ~= sourcePlayer and self.id or direction.id)
			if direction.id ~= 110 then
				if amount == 0 then -- Move everything
					if direction.itemId == 0 then
						inventoryExchangeItemsPosition(self, direction)
					else
						if direction.itemId == self.itemId then
							if direction.amount + self.amount <= 64 then
								itemAdd(direction, self.amount)
								itemRemove(self, sourcePlayer)
							else
								itemAdd(direction, self.amount - (64 - (direction.amount + self.amount)))
								newSlot = self.id
							end
						else
							if self.id == 110 then
								local item = inventoryInsertItem(
									room.player[targetPlayer].inventory,
									self.itemId, self.amount, direction, false
								)
								if item then direction = item end
							end
						end
					end
				else -- Move x amount
					if (self.itemId == direction.itemId or direction.itemId == 0) and self.stackable then
						if self.amount > amount then
							inventoryExtractItem(
								room.player[sourcePlayer].inventory, 
								self.itemId, amount, true
							)
							
							inventoryInsertItem(
								room.player[targetPlayer].inventory,
								self.itemId, amount, direction, true
							)
							newSlot = self.id
						else
							if direction.itemId == 0 then
								inventoryExchangeItemsPosition(self, direction)
							elseif direction.itemId == self.itemId then
								if direction.amount < 64 then
									itemAdd(direction, amount)
									itemRemove(self, sourcePlayer)
								end
							end
						end
					end
			--				
				end
			end
		end
	end
	
	return self, direction, newSlot
end

-- =============== 		PLAYER		============== --

local playerNew = function(playerName, spawnPoint)
	local tfmp = tfm.get.room.playerList[playerName]
	
	local self = {
		name = playerName,
		x = tfmp.x or 0,
		y = tfmp.y or 0,
		tx = 0,
		tx = 0,
		id = tfmp.id,
		spawnPoint = {
			x = spawnPoint and spawnPoint.x or math.random(200, 600),
			y = spawnPoint and spawnPoint.y or 8200
		},
		vx = tfmp.vx or 0,
		vy = tfmp.vy or 0,
		facingRight = tfmp.facingRight or true,
		isAlive = false,
		currentChunk = getPosChunk(spawnPoint.x, spawnPoint.y) or 342,
		lastChunk = getPosChunk(spawnPoint.x, spawnPoint.y),
		lastActiveChunk = getPosChunk(spawnPoint.x, spawnPoint.y),
		timestamp = os.time(),
		keys = {},
		inventory = {
			slot = {},
			interaction = {
				crafting = false,
				furnacing = false
			},
			armor = {},
			selectedSlot = 1,
			slotSprite = nil,
			owner = playerName,
			barActive = false,
			displaying = false
		},
		alert = {
			text = nil,
			timestamp = 0,
			id = -1
		},
		trade = {
			whom = nil,
			isActive = false,
			timestamp = 0 
		}
	}
	
	local _itemNew = itemNew
	for i=1, 36 do
		self.inventory.slot[i] = _itemNew(i, 0, true, 0, false)
		if i <= 10 then
			self.inventory.interaction[i] = _itemNew(100+i, 0, true, 0, true)
		end
	end
	
	return self
end

local playerAlert = function(self, text, offset, color, size)
	if not size then size = text:match("<font[%s+?%S+]*[%s?]*size='(%d+)'[%s?]*>") or 12 end
	
	local lenght = #text:gsub("<.->", "")
	local width = math.ceil((size * lenght) + 10)
	local xpos = 400 - (width/2)
	
	if not offset then offset = 200 - (size/2) end
	
	
	local str = "<p align='center'><font face='Consolas' size='"..size.."'>" .. text .. "</font></p>"
	
	ui.addTextArea(1000, "<font color='#000000'><b>" .. str, self.name, xpos+2, offset+1, width, 0, 0x000000, 0x000000, 1.0, true)	
	ui.addTextArea(1001, "<" .. color .. "><a href='event:alert'>" .. str, self.name, xpos, offset, width, 0, 0x000000, 0x000000, 1.0, true)
	
	self.alert.timestamp = os.time()
end

local playerCleanAlert = function(self)
	if self.alert.timestamp and os.time() > self.alert.timestamp + 1500 then
		eventTextAreaCallback(1001, self.name, "clear")
		self.alert.timestamp = nil
		return true
	end
	
	return false
end

local playerCorrectPosition = function(self)
	if self.x >= 0 and self.x <= 32640 and self.y > 200 then
		if self.lastActiveChunk ~= self.currentChunk and timer > awaitTime then
			local displacement = ((self.lastActiveChunk-1)%85)
			local side = displacement - ((self.currentChunk-1)%85)
			if side ~= 0 then
				local xpos = (displacement * 12) + (side < 0 and 12 or 1)
				local ypos = 256 - map.heightMaps[1][xpos]
				self.x = xpos * 32
				self.y = (ypos * 32) + 200
				tfm.exec.movePlayer(self.name, self.x, self.y, false, 0, -8)
			end
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

local playerUpdate = function(self, x, y, vx, vy, facingRight, isAlive)
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
		end
		
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

local playerUpdateNearChunks = function(self, range, forced)
	local cl, dcl, clj, dclj
	if self.currentChunk then
		for i=-1, 1 do
			cl = self.lastChunk+(85*i)
			dcl = self.currentChunk+(85*i)
			for j=-2, 2 do
				clj = cl+j
				dclj = dcl+j
				
				local crossCondition = globalGrounds < 512 and ( ((i >= -1 and i <= 1) and j == 0) or ((j >= -1 and j <= 1) and i == 0) ) or (j==0 and i==0)
				
				if forced then
					if dclj >= 1 and dclj <= 680 then
						map.handle[dclj] = {dclj, crossCondition and chunkFlush or chunkReload}
					end
				else
					if clj >= 1 and clj <= 680 then
						if not map.handle[clj] then map.handle[clj] = {clj, chunkUnload} end
					end
					
					if dclj >= 1 and dclj <= 680 then
						if (map.handle[dclj] and (map.handle[dclj][2] ~= chunkFlush and map.handle[dclj][2] ~= chunkReload)) or not map.handle[dclj] then -- map.handle[dclj]
							map.handle[dclj] = {dclj, crossCondition and chunkUpdate or chunkLoad}
						end
					end
				end
			end
		end
		
		self.timestamp = os.time()
	end
end

local playerUpdateInventoryBar = function(self)
	local _itemDisplay = itemDisplay
	for i=1, 9 do
		_itemDisplay(self.inventory.slot[27+i], self.name, true)
	end
end

playerGetInventorySlot = function(self, id)
	if id then
		if id < 100 then
			if id >= 1 and id <= 36 then
				return self.inventory.slot[id]
			end
		else
			if id >= 101 and id <= 110 then
				return self.inventory.interaction[id-100]
			end
		end
	end
	
	return nil
end

local playerChangeSlot = function(self, slot)
	local onBar = self.inventory.barActive	
	local dx, dy
	
	if not slot or not ((slot >= 1 and slot <= 36) or (slot > 100 and slot <= 110)) then slot = 1 end
	self.inventory.selectedSlot = slot
	
	local select = playerGetInventorySlot(self, slot)
	dx, dy = itemReturnDisplayPositions(select, self.name)
	
	if self.inventory.slotSprite then tfm.exec.removeImage(self.inventory.slotSprite) end
	if dx and dy then
		local scale = (slot == 110 and (self.inventory.interaction.crafting == 9 and 1.5 or 1.0) or 1.0)
		self.inventory.slotSprite = tfm.exec.addImage(
			"17e4653605e.png", ":10",
			dx-9, (dy-12)+((onBar and slot ~= 110) and 34 or 0),
			self.name,
			scale, scale,
			0.0, 1.0,
			0.0, 0.0
		)
	end
	
	if select.itemId ~= 0 then	
		playerAlert(self, blockMetadata[select.itemId].name, 328 + (self.inventory.barActive and 0 or 32), "D", 14)
	else
		eventTextAreaCallback(1001, self.name, "clear")
	end
end

local inventorySlotsDisplay = function(self, limit)
	local _itemDisplay = itemDisplay
	for i=1, 36 do
		_itemDisplay(self.slot[i], self.owner)
		if i <= limit or i == 10 then
			_itemDisplay(self.interaction[i], self.owner)
		end
	end
end

local playerDisplayInventory = function(self, type)
	local identifier, lim
	self.inventory.barActive = false
	
	self.inventory.displaying = true
	
	if type == "inventory" then
		self.inventory.interaction.crafting = 4
		identifier = "17eb175a263.png"
	elseif type == "craft" then
		self.inventory.interaction.crafting = 9
		identifier = "17eb1755684.png"
	elseif type == "furnace" then
		self.inventory.interaction.furnacing = true
		identifier = "17eb175ee63.png"
	end
	
	lim = self.inventory.interaction.crafting or 2
		
	if self.inventory.sprite then tfm.exec.removeImage(self.inventory.sprite) end
	
	self.inventory.sprite = tfm.exec.addImage(
		identifier, ":1",
		234, 42,
		self.name,
		1.0, 1.0,
		0.0, 1.0,
		0.0, 0.0
	)
	playerChangeSlot(self, self.inventory.selectedSlot)
	
	inventorySlotsDisplay(self.inventory, lim)
end

local playerDisplayInventoryBar = function(self)
	self.inventory.barActive = true
	
	if self.inventory.sprite then tfm.exec.removeImage(self.inventory.sprite) end
	
	self.inventory.sprite = tfm.exec.addImage(
		"17e464e9c5d.png", ":1",
		245, 350,
		self.name,
		1.0, 1.0,
		0.0, 0.85,
		0.0, 0.0
	)
	
	if self.inventory.selectedSlot <= 27 then
		playerChangeSlot(self, 27 + ((self.inventory.selectedSlot-1)%9)+1)
	elseif self.inventory.selectedSlot > 100 then
		playerChangeSlot(self, 28)
	else
		playerChangeSlot(self, self.inventory.selectedSlot)
	end
	playerUpdateInventoryBar(self)
end

local playerHideInventory = function(self)
	self.inventory.interaction.crafting = false
	self.inventory.interaction.furnacing = false
	self.inventory.displaying = false
	local item
	local _itemHide, _itemRemove, _inventoryInsertItem = itemHide, itemRemove, inventoryInsertItem
	
	for i=1, 36 do
		_itemHide(self.inventory.slot[i], self.name)
		if i <= 10 then
			item = self.inventory.interaction[i]
			_itemHide(item, self.name)
			if i ~= 10 then _inventoryInsertItem(self.inventory, item.itemId, item.amount, false, false) end
			_itemRemove(self.inventory.interaction[i], self.name)
		end
	end
	
	playerDisplayInventoryBar(self)
end

local playerPlaceBlock = function(self, x, y)
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

local playerDestroyBlock = function(self, x, y)
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

local playerInitTrade = function(self, whom, activate)
	if whom and self ~= whom then
		self.trade.whom = whom
		self.trade.timestamp = os.time()
		self.trade.isActive = activate or false
	end
end

local playerCancelTrade = function(self)
	self.trade.whom = nil
	self.trade.timestamp = os.time()
	self.trade.isActive = false
end

local blockInteract = function(self, player)
	if self.interact then
		local distance = distance(self.dx+16, self.dy+16, player.x, player.y)
		if distance < 48 then
			playerDisplayInventory(player, "craft")
			--ui.addPopup(769, 0, "You suck so hard", player.name, 350, 190, 100, true)
		else
			playerAlert(player, "You're too far from the "..blockMetadata[self.type].name..".", 328, "N", 14)
		end
	end
end

local playerBlockInteract = function(self, block)
	if block.type ~= 0 then
		if block.interact then
			blockInteract(block, self)
		else
			playerAlert(self, blockMetadata[block.type].name, 328, "D", 14)
		end
	end
end

-- =============== 		START		============== --

local getFixedSpawn = function()
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

local generateBoundGrounds = function()
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

local createNewWorld = function(heightMaps)
	local _math_random, _math_floor, _math_ceil = math.random, math.floor, math.ceil
	local _chunkNew, _structureCreate = chunkNew, structureCreate
	local _ui_updateTextArea, _tfm_exec_addImage, _tfm_exec_removeImage = ui.updateTextArea, tfm.exec.addImage, tfm.exec.removeImage
	local _string_format = string.format
	local chunkList = map.chunk
	
	local locale = {}
	
	local point, surfp
	for i=1, 680 do
		chunkList[i] = _chunkNew(i, false, false, 1, heightMaps)
		
		surfp = heightMaps[1][_math_floor(i*1.5)]
		_ui_updateTextArea(999, _string_format("<p align='center'><font size='48'>Loading...\n%d/680</font>\n<font size='16'>%d</font></p>", i, surfp), nil)
		locale[i] = _tfm_exec_addImage("17e1314ec5f.png", ":"..i, 60+i, 400-_math_ceil(surfp/2), nil, 0.03125, 4.0, 0, 1.0, 0.0, 0.0)
	end
	
	map.spawnPoint = getFixedSpawn()
	xmlLoad = string.format(xmlLoad, map.spawnPoint.x, map.spawnPoint.y)
	
	for i=1, 1040 do
		if _math_random(15) == 1 then
			_structureCreate(1, ((i-1)*32)+16, ((256-heightMaps[1][i])*32)+16)
		end
	end
	
	for i=1, 680 do
		_tfm_exec_removeImage(locale[i])
		chunkCalculateCollisions(chunkList[i])
	end
	

	math.randomseed(os.time())
end

local startPlayer = function(playerName, spawnPoint)
	room.player[playerName] = playerNew(playerName, spawnPoint)
	for k=0, 200 do
		system.bindKeyboard(playerName, k, false, true)
		system.bindKeyboard(playerName, k, true, true)
		room.player[playerName].keys[k+1] = false
	end
	system.bindMouse(playerName, true)
	
	tfm.exec.setAieMode(true, 5.0, playerName)
	eventPlayerDied(playerName)
	if timer > 3000 then
		ui.addTextArea(777, "", playerName, 0, 25, 300, 100, 0x000000, 0x000000, 1.0, true)
		playerUpdateNearChunks(room.player[playerName], 1, true)
	end
	playerDisplayInventoryBar(room.player[playerName])
	playerChangeSlot(room.player[playerName], 28)
end

-- =============== 		EVENTS		============== --

--local loadLoop = {'|', '|', '/', '/', '—', '—', '\\', '\\'}
local loadLoop = {'.', '..', '...'}
function eventLoop(elapsed, remaining)
	if modulo.loading then--timer <= awaitTime then
		if timer < awaitTime then
			ui.updateTextArea(999, string.format("<font size='48'><p align='center'><D><font face='Wingdings' size='64'>6</font>\n%s</D></p></font>", loadLoop[((timer/500)%3)+1]), nil) -- Finishing
		elseif timer >= awaitTime then
			ui.removeTextArea(999, nil)
			tfm.exec.removeImage(modulo.loading)
			modulo.loading = nil
			
			tfm.exec.setWorldGravity(0, 10)
			
			ui.addTextArea(777, "", nil, 0, 25, 300, 100, 0x000000, 0x000000, 1.0, true)
		end
	end
	
	do
		if timer > 10000 and modulo.loading then
			error("Script loading failed.", 2)
		else
			for name, _ in next, tfm.get.room.playerList do
				if room.player[name] then
					if room.player[name].isAlive then
						playerUpdate(room.player[name])
						if room.player[name].timestamp < os.time() - 0 or modulo.loading then
							playerUpdateNearChunks(room.player[name])
							
							if modulo.loading then
								if map.chunk[room.player[name].currentChunk].activated then
									awaitTime = -1000
								else
									if timer >= awaitTime - 1000 then awaitTime = awaitTime + 500 end
								end
							end
						end
					end
					
					playerCleanAlert(room.player[name])
				end
			end
			
			local tt = os.time()
			if map.runtimeLapse < room.runtimeMax - 8 then
				handleChunksRefreshing()
			else
				if map.timestamp + 4000 < os.time() then
					map.runtimeLapse = 0
				end
			end
			tt = (os.time()-tt)+1
			
			if tt >= 3 then
				map.loadingTotalTime = map.loadingTotalTime + tt
				map.totalLoads = map.totalLoads + 1
				map.loadingAverageTime = _math_round(map.loadingTotalTime / map.totalLoads, 2)
				if not room.isTribe then
					local color
					if tt < 10 then color = "VP" elseif tt >= 10 and tt < 20 then color = "CEP" else color = "R" end
					print(string.format("<V>[Event Loop]</V> Chunks updated in <%s>%d ms</%s> (avg. %f ms)", color, tt, color, map.loadingAverageTime))
				end
			end
		end
	end
	
	if globalGrounds > 512 then
		print("<CEP> Warning! <R>" .. globalGrounds .. "</R> is above the safe physic objects count!")--worldRefreshChunks()
		if globalGrounds >= 712 then -- 512
			error(string.format("Physic system destroyed: <CEP>Limit of physic objects reached:</CEP> <R>%d/512", globalGrounds), 2)
		end
	end
	
	timer = timer + 500
end

function eventKeyboard(playerName, key, down, x, y)
	if timer > awaitTime then
		if down then
			room.player[playerName].keys[key+1] = true
			
			if (key >= 49 and key <= 57) or (key >= 97 and key <= 105) then
				playerChangeSlot(room.player[playerName], 27 + (key - (key <= 57 and 48 or 96)))
			end
			
			if key == 72 then -- H
				eventTextAreaCallback(0, playerName, "help")
			elseif key == 46 then -- delete
				local item = playerGetInventorySlot(room.player[playerName], room.player[playerName].inventory.selectedSlot)
				if item then itemRemove(item, playerName) end
			elseif key == 69 then -- E
				if room.player[playerName].inventory.displaying then
					playerHideInventory(room.player[playerName])
				else
					playerDisplayInventory(room.player[playerName], "inventory")
				end
				
				--room.player[playerName].inventory.displaying = (not room.player[playerName].inventory.displaying)
			elseif key == 71 then -- G
				if room.player[playerName].trade.isActive then 
					eventPopupAnswer(11, playerName, "canceled")
				else
					ui.addPopup(10, 2, "<p align='center'>Type the name of whoever you want to trade with.", playerName, 250, 180, 300, true)
				end
			end
		else
			room.player[playerName].keys[key+1] = false
			
			--[[if key == 72 then -- H
				eventTextAreaCallback(201, playerName, "clear")
			end]]
		end
		
		if room.player[playerName] and timer > awaitTime then
			if room.player[playerName].isAlive then playerUpdate(room.player[playerName], x, y, _, _, key < 4 and (key%2==0 and key==2 or nil) or nil) end
		end
	end
end

function eventMouse(playerName, x, y)
	if timer > awaitTime then
		if room.player[playerName].isAlive then
			if (x >= 0 and x < 32640) and (y >= 200 and y < 8392) then
				local isKeyActive = room.player[playerName].keys
				if isKeyActive[19] then -- debug
					local block = getPosBlock(x, y-200)
				elseif isKeyActive[18] then
					playerBlockInteract(room.player[playerName], getPosBlock(x, y-200))
				elseif isKeyActive[17] then
					playerPlaceBlock(room.player[playerName], x, y)
				else
					playerDestroyBlock(room.player[playerName], x, y)
				end
			end
		end
	end
end

function eventPlayerDied(playerName)
	room.player[playerName].isAlive = false
	tfm.exec.respawnPlayer(playerName)
end

function eventPlayerRespawn(playerName)
	tfm.exec.movePlayer(playerName, map.spawnPoint.x, map.spawnPoint.y, false, 0, -8)
	playerUpdate(room.player[playerName], map.spawnPoint.x, map.spawnPoint.y, _, _, true, true)
	--room.player[playerName].isAlive = true
end

function eventNewPlayer(playerName)
	startPlayer(playerName, map.spawnPoint)
	tfm.exec.addImage("17e464d1bd5.png", "?512", 0, 8, playerName, 32, 32, 0, 1.0, 0, 0)
	ui.addTextArea(0, "<p align='right'><font size='18' face='Consolas'> <a href='event:help'>Help</a> ", playerName, 600, 375, 200, 25, 0x000000, 0x000000, 1.0, true)
end

function eventPlayerLeft(playerName)
	room.player[playerName].isAlive = false
end

function eventChatCommand(playerName, command)
	local args = {}
	
	for arg in command:gmatch("%S+") do
		args[#args+1] = arg
	end
	command = args[1]
	
	if args[1] == "help" then
		eventTextAreaCallback(0, playerName, "help")
	elseif args[1] == "seed" then
		ui.addPopup(169, 0, string.format("<p align='center'>World's seed:\n%d", map.seed), playerName, 300, 180, 200, true)
	--[[elseif args[1] == "tp" then
		local pa = tonumber(args[2])
		local pb = tonumber(args[3])
		
		local withinRange = function(a, b) return (a >= 0 and a <= 32640) and (b >= 0 and b <= 8392) end
		
		if pa and pb then
			if withinRange(pa, pb) then tfm.exec.movePlayer(playerName, pa, pb) end
		elseif not pa or not pb then
			local pl = room.player[ args[2] ]
			if pl then
				if pl.isAlive then
					pa = pl.x
					pb = pl.y
					if withinRange(pa, pb) then tfm.exec.movePlayer(playerName, pa, pb) end
				end
			end
		end
		]]
	end
end

local eventPlayerHudInteraction = function(self)
	if self.inventory.interaction.crafting then
		
		local lookup = nil
		local k = 1
		local m = i
		local itemsList = {}
		local _table_insert = table.insert
		
		for i=1, self.inventory.interaction.crafting do
			m = i
			if self.inventory.interaction.crafting == 4 and i > 2 then
				if i == 3 then k = k + 1 end
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
				for j in next, craftsData do
					if self.inventory.interaction[m].itemId == craftsData[j][1][1] then
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
	
	return nil
end

function eventTextAreaCallback(textAreaId, playerName, eventName)
	if timer > awaitTime then
		if (textAreaId > 110 and textAreaId <= 146) or (textAreaId > 210 and textAreaId <= 220) then
			local newSlot = textAreaId - 110
			local select = playerGetInventorySlot(room.player[playerName], textAreaId - 110)
			
			if room.player[playerName].keys[18] or room.player[playerName].keys[17] and textAreaId ~= 220 and select then
				local origin = playerGetInventorySlot(room.player[playerName], room.player[playerName].inventory.selectedSlot)
				if origin then
					local source, destinatary, pass
					
					if room.player[playerName].trade.isActive then
						source, destinatary = playerName, room.player[playerName].trade.whom
						pass = {source, destinatary}
						select = playerGetInventorySlot(room.player[destinatary], 1)
					else
						source, destinatary = playerName, playerName
						pass = playerName
					end
					
					if room.player[playerName].keys[18] then
						origin, select, newSlot = itemMove(origin, select, 0, pass)
					elseif room.player[playerName].keys[17] then
						local quantity = 1
						if origin.id == 110 then quantity = origin.amount end
						origin, select, newSlot = itemMove(origin, select, quantity, pass)
					end

					-- Display both items interacted with
					if (room.player[destinatary].inventory.barActive and (select.id > 27 and select.id <= 36)) or not room.player[destinatary].inventory.barActive then
						itemDisplay(select, destinatary, room.player[destinatary].inventory.barActive)
					end
					if (room.player[source].inventory.barActive and (origin.id > 27 and origin.id <= 36)) or not room.player[source].inventory.barActive  then
						itemDisplay(origin, source, room.player[source].inventory.barActive)
					end
					
					--[[if eventName == "inventory"	then
						return true
					else]]

					
					if eventName == "interaction" or origin.id > 100 or select.id > 100 then -- == 110	
						local display, remove = eventPlayerHudInteraction(room.player[source])
						if display and remove then
							if origin.id == 110 and select.id ~= origin.id then
							
								for i in next, remove do
									inventoryExtractItem(
										room.player[source].inventory, 
										remove[i].itemId, 1, remove[i]
									)
									itemRemove(origin, source)
								end
							else
								itemDisplay(display, destinatary, room.player[source].inventory.barActive)
							end
						else
							itemRemove(room.player[source].inventory.interaction[10], source)
						end
					end
				end
			end
			playerChangeSlot(room.player[playerName], newSlot)
		end
	end
	
	if textAreaId == 0 then
		if eventName == "help" then
			local helpText = "<p align='center'><font size='48' face='Consolas'><D>Help</D></font></p>\n\n<font face='Consolas'>Welcome to <J><b>"..(modulo.name).."</b></J>, script created by <V>"..(modulo.creator).."</V>.\n\n<b>CONTROLS:</b>\n- <u>CLICK:</u> Damage blocks.\n- <u><V>SHIFT</V> + CLICK:</u> Places a block, from selected slot.\n- <u>[1- 9]:</u> Select a slot from inventory. You can also click on them to select.\n- [E]: Opens the main inventory.\n- <u><V>CTRL</V> + CLICK</u>: Exchanges the position of an item from a previous slot to the new clicked one.\n\n\nIf you find any bugs, please report to my Direct Messages in the Forum or through my Discord: <CH>Cap#1753</CH>.\n\nHope you enjoy!"
			ui.addTextArea(200, helpText, playerName, 150, 50, 500, 300, 0x010101, 0x010101, 0.67, true)
			ui.addTextArea(201, "<font size='16'><a href='event:clear'><R><b>X</b></R></a>", playerName, 630, 55, 0, 0, 0x000000, 0x000000, 1.0, true)
		end
	end
	
	if eventName == "clear" or eventName == "alert" then
		ui.removeTextArea(textAreaId, playerName)
		if textAreaId == 201 then
			ui.removeTextArea(200, playerName)
		elseif textAreaId == 1001 then
			ui.removeTextArea(1000, playerName)
		end
	end
end

function eventPopupAnswer(popupId, playerName, answer)
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
end

function eventNewGame()
	generateBoundGrounds()
	tfm.exec.setGameTime(0)
	ui.setMapName(modulo.name)
	--ui.setBackgroundColor("#45a3bf")
	tfm.exec.setWorldGravity(0, 0)
	
	for name, _ in next, tfm.get.room.playerList do
		eventNewPlayer(name)
		--playerUpdate(room.player[name])
		eventPlayerRespawn(name)
	end
	
	--tfm.exec.addImage("17e464d1bd5.png", "!512", 0, 8, nil, 32, 32, 0, 0.33, 0, 0)
end

-- =============== 		MAIN		============== --

local main = function()	
	for i=1, 512 do
		if not blockMetadata[i] then
			blockMetadata[i] = {
				name = "Null",
				drop = 0,
				durability = 18,
				glow = 0,
				translucent = false,
				sprite = "17e1315385d.png",
				particles = {}
			}
		else
			if not blockMetadata[i].sprite then blockMetadata[i].sprite = "17e1315385d.png" end
			if blockMetadata[i].drop == 0 then blockMetadata[i].drop = i end
		end
	end
	
	tfm.exec.disableAfkDeath(true)
	tfm.exec.disableAutoNewGame(true)
	tfm.exec.disableAutoScore(true)
	tfm.exec.disableAutoShaman(true)
	tfm.exec.disableAutoTimeLeft(true)
	tfm.exec.disablePhysicalConsumables(true)
	
	system.disableChatCommandDisplay(nil)
	
	
	if not room.isTribe then
		tfm.exec.setRoomMaxPlayers(10)
		tfm.exec.setPlayerSync(nil) 
		tfm.exec.disableDebugCommand(true)
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

main()

end

xpcall(game, function(err)
	ui.addTextArea(0,
		string.format(
			"<p align='center'><font size='18'><R><B><font face='Wingdings'>M</font> Fatal Error</B></R></font>\n\n<CEP>%s</CEP>\n\n<CS>%s</CS>\n\n\nSend this to Indexinel#5948",
			tostring(err),
			debug.traceback()
		),
		nil,
		200, 100,
		400, 200,
		0x010101, 0x010101,
		0.8, true
	)
	for n in next, _G do
		if string.find(tostring(n), "event") then
			_G[n] = function()
				return
			end
		end
	end
end)
