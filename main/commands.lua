commandList = {}

do
    commandList["lang"] = function(playerName, langcode, targetPlayer)
        if not Text[langcode] then
            langcode = "xx"
        end
		
		if admin[playerName] then
			targetPlayer = targetPlayer or playerName
		else
			targetPlayer = playerName
		end
        
        local Player = room.player[targetPlayer]
        if Player then
            Player.language = langcode
        end
    end
    commandList["language"] = commandList["lang"]
    commandList["idioma"] = commandList["lang"]
    
    
    commandList["seed"] = function(playerName)
        tfm.exec.chatMessage("<CEP><u>World's seed:</u></CEP> <D>" .. map.seed .. "</D>", playerName)
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
        
        printt(Player, {"keys", "slot", "interaction"})
    end
    
    commandList["stackFill"] = function(playerName, itemId, amount, targetPlayer, targetStack)
        if not admin[playerName] then return end
        local Player = room.player[targetPlayer] or room.player[playerName]
        
        if Player then
            local Stack = Player.inventory[targetStack] or Player.inventory.invbar
            
            if Stack then
                itemId = tonumber(itemId)
                
                if itemId then
                    Stack:fill(itemId, tonumber(amount) or 64)
                    
					if Stack.displaying then
						local offset = 0
						if Stack.identifier == "invbar" then
							if Player.inventory.barActive then
								offset = 0
							else
								offset = -36
							end
						end
						
						Stack:refresh(0, offset, true)
					end
                end
            end
        end
    end
	
	commandList["np"] = function(playerName, map)
		if not admin[playerName] then
			return
		else
			tfm.exec.chatMessage("Warning! You're loading a map. Please only do it for testing purposes. Map will be loaded in 3 seconds.", playerName)
			
			appendEvent(3000, false, function(np)
				tfm.exec.newGame(np)
			end, map)
		end
	end
	
	commandList["map"] = commandList["np"]
	
	commandList["lua"] = function(playerName, dir, ...)
		if not admin[playerName] then return end
		
		local obj = _G
		
		for index in dir:gmatch("[^.]+") do
			if type(obj) == "table" then
				obj = obj[index]
			end
		end
		
		if obj then
			local ok, result = pcall(obj, ...)
			
			if result then
				tfm.exec.chatMessage(dump(result), playerName)
			end
		end
	end
	
	commandList["error"] = function(playerName, message)
		if not admin[playerName] then return end
		
		--error()
		errorHandler("Inducted by " .. playerName .. ": " .. message or "")
	end
end
-- Command list on main/commands
commandHandle = function(message, playerName)
	local args = {}
	for arg in message:gmatch("%S+") do
		args[#args+1] = tonumber(arg) or arg
	end
	
	local command = table.remove(args, 1)
	
	local execute = commandList[command]
	if execute then
		local ok, result = pcall(execute, playerName, table.unpack(args))
		
		if not ok then
			for adm, _ in next, admin do
				tfm.exec.chatMessage(result, adm)
			end
			print(result)
			
			return false
		else
			return result
		end
	end
end