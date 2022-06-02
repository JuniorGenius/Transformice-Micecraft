onEvent("WindowCallback", function(windowId, playerName, eventName)
    if not (windowId and playerName and eventName) then
		return
	end
	
	if eventName == "close" then
        uiRemoveWindow(windowId, playerName)
    end
    
    if eventName:sub(1, 4) == "page" then
        local switch = tonumber(eventName:sub(5, -1))
        
        if switch then
			uiUpdateWindowText(windowId, switch, playerName)
        end
    end
	
	uiDisplayDefined(eventName, playerName)
end)

onEvent("WindowDisplay", function(windowId, playerName, windowObject)
	local Player = room.player[playerName]
	
	if Player then
		Player.onWindow = windowId
		
		Player.windowHandle.timestamp = os.time() + Player.windowHandle.delay
		
		if windowObject.height < 325 then
			Player:displayInventoryBar()
		else
			Player:hideInventory()
		end
	end
	
end)

onEvent("WindowHide", function(windowId, playerName, windowObject)
	local Player = room.player[playerName]
		
	if Player then
		Player.onWindow = nil
		
		if not Player.inventory.displaying then
			Player:displayInventoryBar()
		end
	end
	
end)