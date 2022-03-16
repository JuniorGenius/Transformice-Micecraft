blockNew = function(x, y, type, damage, ghost, glow, translucent, mossy, chunk, surfacePoint)
	local xp, yp = getTruePosMatrix(chunk, x, y)
	yp = 256-yp
	
	local meta = blockMetadata[type]
	
	local block = {
		x = xp,
		y = yp,
		rx = x,
		ry = y,
		
		id = ((x-1)*32) + y,
		gid = (((chunk-1)*384)+((x-1)*32)+y),
		act = (type == 0 or ghost) and 0 or -1,
		chunk = chunk,

		type = type,
		ghost = ghost or false,
		glow = glow or false,
		translucent = translucent or false,
		mossy = mossy or false,
		
		damage = damage or 0,
		damagePhase = 0,
		
		shadowness = (ghost and not translucent) and 0.33 or 0,
		sprite = {},
		alpha = 1.0,
		dx = xp*32,
		dy = ((256-yp)*32)+200,
		
		interact = type ~= 0 and meta.interact or false,
		
		onInteract = nil,--meta.onInteract or defaultOnInteract,
		onDestroy = nil,--meta.onDestroy or defualtOnDestroy,
		onCreate = nil--meta.onCreate or defaultOnCreate
	}
	
	--[[if type ~= 0 then
		local chunkk = map.chunk[chunk]
		block.shadowness = (distance(0, yp, 0, surfacePoint)/8)*0.67--128
		if block.shadowness > 0.67 then block.shadowness = 0.67 end
	end]]
	block.sprite = {
		[1] = {
			block.type >= 1 and meta.sprite or nil,
			nil, --block.type >= 1 and mossSprites[--[[map.chunk[chunk].biome]]1] or nil,
			shadowSprite,
			nil,
		},
		[2] = {
		}
	}
	
	return block
end