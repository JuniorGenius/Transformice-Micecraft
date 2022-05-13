local _ui_addTextArea = ui.addTextArea
local _ui_removeTextArea = ui.removeTextArea
local _ui_updateTextArea = ui.updateTextArea
local _tfm_exec_addImage = tfm.exec.addImage
local _tfm_exec_removeImage = tfm.exec.removeImage
local textAreaHandle = {}
local textAreaNum = 0

uiCreateElement = function(id, order, target, element, text, xoff, yoff, alpha)
    local lhandle = {}
    if element.type == "image" then
        local imgTarget = (element.foreground and '&' or ':') .. (5000 + id)
        lhandle.id = _tfm_exec_addImage(
            element.image, imgTarget,
            element.xcent + xoff, element.ycent + yoff,
            target,
            1.0, 1.0,
            0, alpha,
            0, 0
        )
    elseif element.type == "textArea" then
        if element.container then
            local access = text[element.identifier]
            if element.multiplecont then
                lhandle.texts = {}
                    
                if type(access) == "table" then
                    for i=1, #access  do
                        lhandle.texts[i] = access[i] or ""
                    end
                end
                lhandle.index = 1
                lhandle.text = lhandle.texts[1]
            else
                lhandle.text = access or ""
            end
            
            if element.format then
                lhandle.text = element.format.start .. lhandle.text .. element.format.enclose
            end
        else
            if element.text then
                lhandle.text = element.text:format(element.event) 
            end
        end
        
        textAreaNum = textAreaNum + 1
        lhandle.id = 5000 + textAreaNum
        _ui_addTextArea(
            lhandle.id,
            lhandle.text,
            target,
            element.xcent + xoff, element.ycent + yoff,
            element.width, element.height,
            0x000000, 0x000000,
            alpha, true
        )
        
        textAreaHandle[lhandle.id] = id
    end
    
    return lhandle
end

uiCreateWindow = function(id, _type, target, text, xoff, yoff, alpha)
    if not target then
        print("Warning ! uiCreateWindow target is not optional.")
        return
    end
    
    _type = _type or 0
    text = type(text) == "string" and {default=text} or (text or {})
    
    xoff = xoff or 0
    yoff = yoff or 0
    alpha = alpha or 1.0
    
    local resources = uiResources[_type] or uiResources[0]

    local texts = 0
    local height, width = 0, 0
    local handle = {}
    local lhandle 
    for order, element in next, resources do
        lhandle = {}
        
        lhandle = uiCreateElement(id, order, target, element, text, xoff, yoff, alpha)
        lhandle.remove = element.remove
        lhandle.update = element.update
        
        if (element.height or 0) > height then
            height = element.height
        end
        
        if (element.width or 0) > width then
            width = element.width
        end
        
        handle[#handle + 1] = lhandle
        lhandle = nil
    end
    
    handle.height = height
    handle.width = width
    
    return handle
end

uiGivePlayerList = function(targetPlayer)
    local playerList = {}
    
    local typeList = type(targetPlayer)
    if typeList == "string" then
        playerList = {targetPlayer}
    else
        if typeList == "table" then
            playerList = targetPlayer
        else
            local hlist = unreference(map.userHandle)

            for playerName, _ in next, hlist do
                playerList[#playerList + 1] = playerName
            end
        end
    end
    
    return playerList
end

uiAddWindow = function(id, type, text, targetPlayer, xoffset, yoffset, alpha, reload)
    local playerList = uiGivePlayerList(targetPlayer)

    if not uiHandle[id] then
        uiHandle[id] = {
            reload = reload or false
        }
    end
    
    for _, playerName in next, playerList do
        if uiHandle[id][playerName] then
            uiRemoveWindow(id, playerName)
        end
        local success = uiCreateWindow(id, type, playerName, text, xoffset, yoffset, alpha)
        if success then 
            uiHandle[id][playerName] = success
            eventWindowDisplay(id, playerName, success)
        end
    end
end

uiHideWindow = function(id, targetPlayer)
    local object = uiHandle[id][targetPlayer]
    
    if object then
        eventWindowHide(id, targetPlayer, object)
        for key, element in next, object do
            if type(element) == "table" then
                element.remove(element.id, targetPlayer)
            end
        end
    end
end

uiRemoveWindow = function(id, targetPlayer)
    local localeWindow = uiHandle[id]
    local playerList = uiGivePlayerList(targetPlayer)
    
    if localeWindow then
        for _, playerName in next, playerList do
            uiHideWindow(id, playerName)
            
            if localeWindow[playerName] then
                localeWindow[playerName] = nil
            end
        end
    end
    
    if not targetPlayer then
        localeWindow = nil
    end
    
    return true
end

uiUpdateWindowText = function(windowId, updateText, targetPlayer)
    local Window = uiHandle[windowId]
    local playerList = uiGivePlayerList(targetPlayer)
    local _type = type(updateText)
    if Window then
        local WinPlayer
        local element, text
        for _, playerName in next, playerList do
            WinPlayer = uiHandle[playerName]
            
            if WinPlayer then
                element = WinPlayer[2]
                if element then
                    if type(element.text) == "table" then
                        element.index = element.index + tonumber(updateText) or 1
                        local eindex = element.index
                        local tsize = #element.text
                        if eindex > tsize then
                            eindex = eindex - tsize
                        elseif eindex <= 0 then
                            eindex = eindex + tsize
                        end
                        
                        text = element.text[element.index] or ""
                    else
                        element.text = updateText or ""
                        text = updateText
                    end
                    element.update(element.id, text, playerName)
                end
            end
        end
    end
end