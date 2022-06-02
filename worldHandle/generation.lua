worldSetHeightMap = function(heightMap, World)
    local map = heightMap.map[1](table.unpack(heightMap.map[2]))
    local dir = heightMap.dir
    
    local extent = #map
    
    local height, width = #World, #World[1]
    
    local xstart = heightMap.start or 1
    local xend = xstart + extent
    if xend > width then
        xend = width
    end
    
    local xoff, yoff
    local ystart
    
    local lastdir = {0, true}
    
    for x = xstart, xend do
        xoff = (x - xstart) + 1
        ystart = map[xoff] or 1
        lastdir = {0, true}
        for y = ystart, height do
            yoff = (y - ystart) + 1
            if dir[yoff] then
                lastdir = {
                    dir[yoff][1],
                    dir[yoff][2]
                }
            end
            
            if lastdir[1] == -1 then
                break
            end
            
            World[y][x] = {
                lastdir[1] == nil and World[y][x][1] or lastdir[1],
                lastdir[2] == nil and World[y][x][2] or lastdir[2]
            }
        end
    end
    
    return map
end

worldSetNoiseMap = function(noiseMap, World)
    local map = noiseMap.map[1](table.unpack(noiseMap.map[2]))
    local dir = noiseMap.dir.exclusive
    
    local line
    local block
    local cell
    for y=1, #World do
        line = map[y] or {}
        for x=1, #World[1] do
            cell = line[x]
            if cell then
                if World[y][x][1] == dir[1] or not dir[1] then
                    if World[y][x][2] == dir[2] or not dir[2] then
                        World[y][x] = {
                            cell or 0,
                            dir[2] == nil and World[y][x][2] or dir[2]
                        }
                    end
                end
            end
        end
    end
    return map
end

setStructure = function(structure, World, x, y, overwrite, tvar)
    local yo, xo
    local dir
    local mem
    tvar = tvar or {}
    local sum = tvar[math.random(#tvar)] or 0
    for i=1, #structure do
        dir = structure[i]
        if type(dir) == "table" then
            yo = y + dir[4]
            xo = x + dir[3]
            if World[yo] and World[yo][xo] then
                if overwrite or World[yo][xo][1] == 0 then
                    World[yo][xo] = {
                        dir[1] + sum,
                        dir[2]
                    }
                end
            end
        end
    end
end

worldSetStructures = function(def, World, maps)
    local map = maps[def.pointer]
    local dir = def.dir
    if def.repeats then        
        local x = dir.start or 1
        local y
        local struct = def.structure
        local width = dir.finish or #World[1]
        local min = dir.min or 1
        local max = dir.max or width
        local overwrite = def.overwrite
        local tvar = dir.tsum
        
        local vars = (min ~= max)
        
        while x <= width do
            if vars then
                x = x + math.random(min, max)
            end
            y = map[x]
            if not y then
                break
            else
                setStructure(struct, World, x, y, overwrite, tvar)
            end
            x = x + 1
        end
    end
    
    return true
end

generateNewWorld = function(height, width, worldDef)
    local World = {} -- height
    
    for y=1, height do
        World[y] = {} -- width
        for x=1, width do
           World[y][x] = {0, true} 
        end
    end
    
    local previous = {}
    
    for id, def in next, worldDef do
        previous[#previous + 1] = def:set(World, previous)
    end
    
    map.worldMatrix = World
end