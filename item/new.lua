itemNew = function(objectId, name)
    local meta = objectMetadata[objectId]
    local item = inherit(meta, {
        name = name or meta.name,
        sprite = {[1] = meta.sprite},
        damage = meta.durability or 0,
        timestamp = 0
    })

    if item.sharpness == 0 then
        item.sharpness = 2
    end
    
    if item.strenght == 0 then
        item.strenght = 2
    end
   
    return item
end

itemDelete = function(self)
    if self.sprite[2] then
        _tfm_exec_removeImage(self.sprite[2])
    end
    
    local retval = unreference(self)
    self = nil
   
    return retval
end

--[[
  ftype = { -- Efectivity against n type of block
    [0-7] = xR
		0: all
		1: sands
		2: dirts
		3: weak obj/leaf
		4: woods
		5: rocks/metal
		6: wool
		7: glass
  },]]