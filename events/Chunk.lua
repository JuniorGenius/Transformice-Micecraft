onEvent("ChunkActivated", function(Chunk)
    
end)

onEvent("ChunkDeactivated", function(Chunk)
    
end)

onEvent("ChunkLoaded", function(Chunk)
    if modulo.loading then
        modulo:updatePercentage(23, "Loading...")
    end
end)

onEvent("ChunkUnloaded", function(Chunk)
    
end)