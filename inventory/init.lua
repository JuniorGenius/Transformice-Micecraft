stackNew = function(size, owner, dir, idoffset, name)
    if not dir then dir = {} end
    
    local stack = {
        slot = {},
        identifier = name or "bridge",
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