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

dump = function(var, nest)
	nest = nest or 1
	if type(var) == "table" then
		local str = (nest == 1 and tostring(var):gsub("table: ", "") .. " =" or "") .. " {\n"
		for k, v in pairs(var) do
			local isNumber = type(k) == "number"
			k = "<CEP>" .. k .. "</CEP>"
			if isNumber then k = "["..k.."]" end
			str = str .. string.rep("\t", nest) .. k .. " = " .. dump(v, nest+1) .. ",\n"--( and ",\n" or "\n")
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

printt = function(var)
	local _, val = pcall(dump, var)
	print("<N2>" .. val .. "</N2>")
end

getPosChunk = function(x, y, passObject)
	if x < 0 then x = 1 
	elseif x > 32640 then x = 32639 end
	if y < 0 then y = 1
	elseif y > 8192 then y = 8191 end
	
	local yc = 85*math.floor((y/32)/32)
	local xc = math.floor((x/32)/12)
	local eq = yc + xc + 1
	return passObject and map.chunk[eq] or eq
end

getPosBlock = function(x, y)
	if x < 0 then x = 1 
	elseif x > 32640 then x = 32639 end
	if y < 0 then y = 1
	elseif y > 8192 then y = 8191 end

	local chunk = getPosChunk(x, y)
	return map.chunk[chunk].block[1+(math.floor(y/32)%32)][1+(math.floor(x/32)%12)]
end

getTruePosMatrix = function(chunk, x, y)
	return (((chunk-1)%85)*12)+(x-1), (math.floor((chunk-1)/85)*32)+(y-1)
end

spreadParticles = function(particles, amount, kind, xor, yor)
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

getBlocksAround = function(self, include, cross)
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

