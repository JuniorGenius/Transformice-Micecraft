onEvent("SlotSelected", function(Player, newSlot)
--[[    local oldSlot = Player.inventory.selectedSlot
    
    
    local oldstack, newstack = oldSlot.stack, newSlot.stack
    if Player.inventory[newstack].del then]]
end)