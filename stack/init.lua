function _Stack.new(size, owner, dir, idoffset, name)
    local self = setmetatable({}, _Stack)
    if not dir then dir = {} end

    self.slot = {}
    self.identifier = name or "bridge"
    self.owner = owner
    self.sprite = {
        dir.sprite,
        {
            x=dir.xStart or 0,
            y=dir.yStart or 0
        },
        nil
    }
    self.offset = idoffset
    self.output = dir.output
    self.displaying = false
        
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
        self.slot[i] = _Slot.new(idoffset + i, 0, false, 0, ddat[i], self.identifier)
    end
    
    return self
end

function _Stack:fill(element, amount)
    local slotList = self.slot
    if element ~= 0 then
        for i=1, #self.slot do
            slotList[i]:fill(element, amount, amount ~= 0)
        end
        
        return true
    else
        return self:empty()
    end
end
 
function _Stack:empty()
    local slotList = self.slot
    for i=1, #self.slot do
        slotList[i]:empty(self.owner)
    end
    
    return true 
end