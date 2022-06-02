worldPresets = {}

worldPresets["overworld"] = {}
do
    worldPresets["overworld"][1] = {
        set = worldSetHeightMap,
        map = {generatePerlinHeightMap, {30, 24, 64, 1020, 128}},
        dir = {
            [1] = {2, false},
            [2] = {1, false},
            [6] = {10, false}
        },
        heightMap = true
    }
        
    for i = 2, 7 do
        local offset = (i - 1) * 20
        worldPresets["overworld"][i] = {
            set = worldSetHeightMap,
            map = {generatePerlinHeightMap, {20, 12, 220+offset, worldWidth, 114+offset}},
            dir = {
                [1] = {nil, true},
                [5] = {-1, true}
            },
            heightMap = true
        }
    end
    
    worldPresets["overworld"][8] = {
        set = worldSetNoiseMap,
        map = {
            generateNoiseMap, {worldHeight, worldWidth, 0.075, 0.75, {
                11, 12, 13, 14, 15, 16}
            }
        },
        dir = {
            exclusive = {10}
        }
    }
    
    worldPresets["overworld"][9] = {
        set = worldSetStructures,
        pointer = 1,
        repeats = true,
        dir = { -- yoff, xoff, wrepeat, times, xsep = table or num, ysep 
            min = 4,
            max = 18,
            tsum = {2, 4}
        },
        structure = structureData[1],
        overwrite = false
    }
end