local onPredefinedRegister = {
    ["help"] = true,
    ["controls"] = true,
    ["reports"] = true,
    ["credits"] = true
}

uiDisplayDefined = function(typedef, playerName)
    local Player = room.player[playerName]
    local lang = Player and Player.language or room.language
    local title = "<font face='Consolas' color='#000000' size='18'><p align='center'>"
    local default = "<font face='Consolas' color='#ffffff'>"

    
    if onPredefinedRegister[typedef] then
        if typedef == "help" then
            title = translate("help title", lang)
            default = translate("help desc", lang,
                {modulo=modulo.name})
            confirm = true
        elseif typedef == "controls" then
            title = translate("controls title", lang)
            default = translate("controls desc", lang,
                {modulo=modulo.name})
        elseif typedef == "reports" then
            title = translate("reports title", lang)
            default = translate( "reports desc", lang,
            {username=modulo.creator, discord = modulo.discreator})
        elseif typedef == "credits" then
            title = translate("credits title", lang)
            default = translate("credits desc", lang, {creator= modulo.creator})
        end
        uiAddWindow(0, 0.5,
            {title = title, default = default},
            playerName, 0, 0, false
        )
    end
end