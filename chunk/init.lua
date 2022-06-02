function _Chunk.new(id, loaded, activated, biome)
	local self = setmetatable({}, _Chunk)
	local _blockNew = blockNew

	local xc = ((id-1) % chunkRows) * chunkWidth
	
	local yc = math.floor((id-1)/chunkRows) * chunkHeight
	local nyc = (worldHeight - yc)

	local ioff = (id-1) * chunkSize

	self.id = id
	self.loaded = false
	self.activated = false
	self.biome = biome or 1
	self.block = {}
	self.interactable = {}
	self.grounds = {
		[1] = {},
		[2] = {}
	}
	self.segments = {}
	self.x = blockSize * xc
	self.y = (blockSize * yc) + worldVerticalOffset
	self.ioff = ioff
	self.timestamp = 0
	self.userHandle = {}
	
	
	for y=1, chunkHeight do
		self.block[y] = {}
	end
	
	local ghost, type, yr, xr, ya
	
	local matrix = map.worldMatrix 
	local dir
	for x=1, chunkWidth do
		xr = xc + x
		for y=1, chunkHeight do
			yr = nyc - y
			ya = yc + y
			
			dir = matrix[ya][xr]

			if yr <= 1 then
				type = 256
				ghost = false
			else
				type = dir[1]
				ghost = dir[2]
			end
			
			self.block[y][x] = _blockNew(
				x, -- x
				y, -- y
				type, -- type
				0,  -- damage
				(ghost or type == 0), -- ghost
				false, -- glow 
				false, -- translucent
				false, -- mossy
				id, -- chunk
				ya,
				ioff
			)
		end
	end
	
	return self
end

function _Chunk:calculateCollisions()
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
			local _width = blockSize * ((xend - xstr) + 1)
			local _height = blockSize * ((yend - ystr) + 1)
			
			_table_insert(self.segments, assign)
			_table_insert(segments, assign)
			
			self.grounds[1][assign] = {
				id = self.ioff + assign,
				xPos = self.x + (blockSize * (xstr - 1)) + (_width / 2),
				yPos = self.y + (blockSize * (ystr - 1)) + (_height / 2),
				bodydef = {
					type = 14,--14,
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