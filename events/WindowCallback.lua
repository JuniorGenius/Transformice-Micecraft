onEvent("WindowCallback", function(windowId, playerName, eventName)
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



