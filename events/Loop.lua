local _os_time = os.time
local tt
onEvent("Loop", function(elapsed, remaining)
	if modulo.loading then
		if timer <= 500 then
			--tfm.exec.removeImage(modulo.loadImg[2][3])
			ui.addTextArea(1001, "", nil, 50, 200, 700, 0, 0x000000, 0x000000, 1.0, true)
		elseif timer <= awaitTime then
			ui.updateTextArea(1001, string.format("<font size='48'><p align='center'><D><font face='Wingdings'>6</font>\n%s</D></p></font>", ({'.', '..', '...'})[((timer/500)%3)+1]), nil) -- Finishing
		else
			eventLoadFinished()
		end
	end
end)

onEvent("Loop", function(elapsed, remaining)
	if timer >= 15000 and modulo.loading then
		error(translate("errors worldfail", room.language))
	end
	
	if timer%5000 == 0 and not modulo.timeout then
		setWorldGravity(0, 10)
	end 
		
	if globalGrounds > groundsLimit - 36 then
		if globalGrounds <= groundsLimit then
			worldRefreshChunks()
		else
			error(translate("errors physics_destroyed", room.language,
				{current=globalGrounds, limit=groundsLimit})
			)
		end
	end
	
	timer = timer + 500
end)

onEvent("Loop", function(elapsed, remaining)
	
	for playerName, Player in next, room.player do
		if Player.isAlive then
			playerLoopUpdate(Player)
			
			if modulo.loading then
				if map.chunk[Player.currentChunk].activated then
					awaitTime = -1000
				else
					if timer >= awaitTime - 1000 then
						awaitTime = awaitTime + 500
					end
				end
			end
				
			if Player.static and _os_time() > Player.static then
				playerStatic(Player, false)
			end
		else
			if modulo.loading then
				tfm.exec.respawnPlayer(playerName)
			end
		end
		
		playerCleanAlert(Player)
	end
end)

onEvent("Loop", function(elapsed, remaining)
	if _os_time() > map.timestamp + 4000 then
		if modulo.runtimeLapse > 1 then
			modulo.timeout = false
		end
		modulo.runtimeLapse = 0
	end
		
	if modulo.runtimeLapse < modulo.runtimeLimit then
		handleChunksRefreshing()
	end
		
	if modulo.runtimeLapse >= modulo.runtimeLimit then
		for _, Player in next, room.player do
			if not Player.static then
				playerStatic(Player, true)
				playerAlert(Player, ("<b>%s</b>"):format(
					translate("modulo timeout", Player.language)
				), nil, "CEP", 48, 3900)
				
			end
		end
		modulo.timeout = true
	end
end)

onEvent("Loop", function(elapsed, remaining)
	local HNDL = actionsHandle
	local lenght = #HNDL
	
	local ok, result, action
	
	local _table_unpack = table.unpack
	
	local i = 1
	while i <= lenght do
		action = HNDL[i]
		if _os_time() >= action[1] then
			if modulo.runtimeLapse < modulo.runtimeLimit then
				local tt = _os_time()
				ok, result = pcall(action[2], _table_unpack(action[3]))
				if not ok then 
					warning("[eventAppend Handler] " .. result)
				end
				table.remove(HNDL, i)
				lenght = lenght - 1
				
				modulo.runtimeLapse = modulo.runtimeLapse + (_os_time() - tt)
			else
				break
			end
		else
			i = i + 1
		end
	end
end)