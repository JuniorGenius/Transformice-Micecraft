stackDisplay = function(self, xOffset, yOffset, displaySprite)
    local _slotDisplay = slotDisplay
    
    if displaySprite then
        if self.sprite and self.sprite[1] then
            if self.sprite[3] then
                tfm.exec.removeImage(self.sprite[3])
            end
            
            self.sprite[3] = _tfm_exec_addImage(
                self.sprite[1], "~1",
                self.sprite[2].x+(xOffset or 0), self.sprite[2].y+(yOffset or 0),
                self.owner,
                1.0, 1.0,
                0, 1.0,
                0, 0
            )
        end
    end

    
    for i=1, #self.slot do
        _slotDisplay(self.slot[i], self.owner, xOffset or 0, yOffset or 0)
    end
    
    self.displaying = true
    
    return true
end

stackHide = function(self)
    if not self then return end
    local _slotHide = slotHide

    if self.sprite[3] then
        _tfm_exec_removeImage(self.sprite[3])
        self.sprite[3] = nil
    end
    
    for i=1, #self.slot do
        _slotHide(self.slot[i], self.owner)
    end
    
    self.displaying = false
    
    return true
end

stackRefresh = function(self, xOffset, yOffset, displaySprite)
    stackHide(self)
    stackDisplay(self, xOffset, yOffset, displaySprite)
end