withinRange = function(a, b)
    return  (a >= 0 and a <= 32640) and (b >= 200 and b <= 8392)
end

commandList = {}

do
    commandList["lang"] = function(playerName, langcode, targetPlayer)
        if not Text[langcode] then
            langcode = "xx"
        end
        targetPlayer = targetPlayer or playerName
        
        local Player = room.player[targetPlayer]
        if Player then
            Player.language = langcode
        end
    end
    commandList["language"] = commandList["lang"]
    commandList["idioma"] = commandList["lang"]
    
    
    commandList["seed"] = function(playerName)
        tfm.exec.chatMessage("World's seed: " .. map.seed, playerName)
    end
    commandList["worldseed"] = commandList["seed"]
    commandList["semilla"] = commandList["seed"]
    
    commandList["tp"] = function(playerName, x, y, z)
        if not admin[playerName] then return end
        
        local pa, pb
        
        local Player = room.player[playerName]
        
        local tx, ty, tz = type(x), type(y), type(z)
        if x and y then
            if tx == "string" and ty == "string" then
                local Target1 = room.player[x]
                local Target2 = room.player[y]
                
                if Target1 and Target2 then
                    playerName = x
                    pa, pb = Target2.x, Target2.y
                end
            elseif ty == "number" then
                if tx == "number" then
                    pa, pb = x, y
                else
                    local Target = room.player[x]
                    if type(z) == "number" then
                        if Target then
                            playerName = x
                            pa, pb = y, z
                        end
                    end
                end
            end
        elseif x and not y then
            if tx == "string" then
                local Target = room.player[x]
                
                if Player and Target then
                    pa, pb = Target.x, Target.y
                end
            end
        end
        
        if pa and pb then
            if withinRange(pa, pb) then
               _movePlayer(playerName, pa, pb) 
            end
        end
    end
    commandList["teleport"] = commandList["tp"]
    
    commandList["debug"] = function(playerName, targetPlayer)
        if not admin[playerName] then return end
        
        local Player = room.player[targetPlayer] or room.player[playerName]
        
        printt(Player, {"keys", "slot", {"interaction"})
    end
    
    commandList["stackFill"] = function(playerName, itemId, amount, targetPlayer, targetStack)
        if not admin[playerName] then return end
        local Player = room.player[targetPlayer] or room.player[playerName]
        
        if Player then
            local Stack = Player.inventory[targetStack] or Player.inventory.invbar
            
            if Stack then
                itemId = tonumber(itemId)
                
                if itemId then
                    stackFill(
                        Stack,
                        itemId,
                        tonumber(amount) or 64
                    )
                    
                    local offset = 0
                    if Stack.identifier == "invbar" then
                        if Player.inventory.barActive then
                            offset = 0
                        else
                            offset = -36
                        end
                    end
                    
                    stackRefresh(Stack, 0, offset)
                end
            end
        end
    end
end

-- Command list on main/commands
commandHandle = function(message, playerName)
	local args = {}
	local command
	for arg in command:gmatch("%S+") do
		args[#args+1] = tonumber(arg) or arg
	end
	
	command = table.remove(args, 1)
	
	local execute = commandList[command]
	if execute then
		return execute(playerName, table.unpack(args))
	end
end