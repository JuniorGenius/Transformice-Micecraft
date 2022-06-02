function _Stack:display(xOffset, yOffset, displaySprite)
    
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

    local slotList = self.slot
    for i=1, #slotList do
        slotList[i]:display(self.owner, xOffset or 0, yOffset or 0)
    end
    
    self.displaying = true
    
    return true
end

function _Stack:hide()
    if self.sprite[3] then
        _tfm_exec_removeImage(self.sprite[3])
        self.sprite[3] = nil
    end
    
    local slotList = self.slot
    for i=1, #slotList do
        slotList[i]:hide(self.owner)
    end
    
    self.displaying = false
    
    return true
end

function _Stack:refresh(xOffset, yOffset, displaySprite)
    self:hide()
    self:display(xOffset, yOffset, displaySprite)
end