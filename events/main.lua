onEvent("LoadFinished", function()
	modulo.loading = false
  
	ui.removeTextArea(999, nil)
	for _, img in next, modulo.loadImg[2] do
		tfm.exec.removeImage(img)
	end
	
	setWorldGravity(0, 10)
	--ui.addTextArea(777, "", nil, 0, 25, 300, 100, 0x000000, 0x000000, 1.0, true)
end)


require("Loop")

require("Controls")

onEvent("PlayerDied", function(playerName, override)
	local Player = room.player[playerName]
	if Player then
		Player.isAlive = false
		if override then
			tfm.exec.respawnPlayer(playerName)
		else
			ui.addTextArea(42069, ("\n\n\n\n\n\n\n\n<p align='center'><font face='Soopafresh' size='42'><R>%s</R></font>\n\n\n<font size='28' face='Consolas' color='#ffffff'><a href='event:respawn'>%s</a></font></p>"):format(
		translate("alerts death", Player.language),
		translate("alerts respawn", Player.language)
	
	), playerName, 0, 0, 800, 400, 0x010101, 0x010101, 0.4, true)
		end
	else
		ui.addTextArea(42069, "\n\n\n\n\n\n\n\n\n\n\n<p align='center'><font face='Soopafresh' size='42'><R>You've been disabled from playing Micecraft.</R></font></p>", playerName, 0, 0, 800, 400, 0x010101, 0x010101, 1.0, true)
	end
end)

onEvent("PlayerRespawn", function(playerName)
	local Player = room.player[playerName]
	if Player then
		_movePlayer(playerName, map.spawnPoint.x, map.spawnPoint.y, false, 0, -8)
		playerActualizeInfo(Player, map.spawnPoint.x, map.spawnPoint.y, _, _, true, true)
	end
end)

onEvent("NewPlayer", function(playerName)
	startPlayer(playerName, map.spawnPoint)
	tfm.exec.addImage("17e464d1bd5.png", "?512", 0, 8, playerName, 32, 32, 0, 1.0, 0, 0)
	local lang = room.player[playerName].language
	ui.addTextArea(0,
		("<p align='right'><font size='12' color='#ffffff' face='Consolas'><a href='event:credits'>%s</a> &lt;\n <a href='event:reports'>%s</a> &lt;\n <a href='event:controls'>%s</a> &lt;\n <a href='event:help'>%s</a> &lt;\n"):format(
		translate("credits title", lang),
		translate("reports title", lang),
		translate("controls title", lang),
		translate("help title", lang)
	),
	playerName, 700, 330, 100, 70, 0x000000, 0x000000, 1.0, true)
	generateBoundGrounds()
	if not room.isTribe then
		tfm.exec.lowerSyncDelay(playerName)
	end
end)

onEvent("PlayerLeft", function(playerName)
	room.player[playerName] = nil
	map.userHandle[playerName] = nil
end)

onEvent("ChatCommand", function(playerName, command)
	local args = {}
	
	for arg in command:gmatch("%S+") do
		args[#args+1] = arg
	end
	command = args[1]
	
	uiDisplayDefined(args[1], playerName)

	if command == "lang" or command == "language" then
		room.player[playerName].language = args[2] or "xx"
	elseif args[1] == "seed" then
		ui.addPopup(169, 0, string.format("<p align='center'>World's seed:\n%d", map.seed), playerName, 300, 180, 200, true)
	elseif args[1] == "tp" then
		if room.isTribe or playerName == modulo.creator then
			local pa = tonumber(args[2])
			local pb = tonumber(args[3])
			
			local withinRange = function(a, b) return (a >= 0 and a <= 32640) and (b >= 0 and b <= 8392) end
			
			if pa and pb then
				if withinRange(pa, pb) then _movePlayer(playerName, pa, pb) end
			elseif not pa or not pb then
				local pl = room.player[ args[2] ]
				local tgt = room.player[args[3]]
				if pl then
					if pl.isAlive then
						if tgt then
							playerName = pl.name
							pa = tgt.x
							pb = tgt.y
						else
							pa = pl.x
							pb = pl.y
						end
						if withinRange(pa, pb) then _movePlayer(playerName, pa, pb) end
					end
				end
			end
		end
	elseif args[1] == "debug" then
		local player = room.player[args[2]]
		
		if player then printt(player, {"keys", "slot", "interaction"}) end
	elseif args[1] == "announce" or args[1] == "chatannounce" then
		if playerName == modulo.creator then
			local _output = "<CEP><b>[Room Announcement]</b></CEP> <D>"
			for i=2, #args do
				_output = _output .. args[i] .. " "
			end
			_output = _output .. "</D>"
      
			if args[1] == "chatannounce" then
				tfm.exec.chatMessage(_output, nil)
			else
				ui.addTextArea(42069, "<a href='event:clear'><p align='center'>" .. _output, nil, 100, 50, 600, 300, 0x010101, 0x010101, 0.4, true)
			end
		end
	elseif args[1] == "stackFill" then
		local player = room.player[args[4] or playerName]
		if playerName == modulo.creator then
			stackFill(player.inventory.invbar, tonumber(args[2]), tonumber(args[3]) or 64)
			stackRefresh(player.inventory.invbar, 0, player.inventory.barActive and 0 or -36, player.inventory.barActive)
		end
	elseif args[1] == "disable" and playerName == modulo.creator then
		if room.player[args[2]] then
			room.player[args[2]]= nil
			tfm.exec.killPlayer(args[2])
		end
	elseif args[1] == "enable" and playerName == modulo.creator then
		if not room.player[args[2]] then
			room.player[args[2]] = playerNew(args[2], map.spawnPoint)
			ui.removeTextArea(42069, args[2])
			tfm.exec.respawnPlayer(args[2])
		end
	end
end)

require("Inventory")

require("TextAreaCallback")

require("WindowCallback")

onEvent("PopupAnswer", function(popupId, playerName, answer)
	return nil
	--[[
	if room.player[playerName] then
		if popupId == 10 then
			if room.player[playerName].trade.timestamp < os.time() - 15000 then
				if room.player[answer] then
					if playerName ~= answer then
						if not room.player[answer].trade.whom then
							playerInitTrade(room.player[playerName], answer)
							playerInitTrade(room.player[answer], playerName)
							ui.addPopup(11, 1, "<p align='center'>Do you want to trade with <D>"..(playerName).."</D>?", answer, 325, 100, 150, true)
						else
							ui.addPopup(10, 0, "<p align='center'>The user <CEP>"..(answer).."</CEP> is currently trading with another person.", playerName, 250, 180, 300, true)
						end
					else
						ui.addPopup(10, 0, "<p align='center'>You can't trade with yourself.", playerName, 250, 180, 300, true)
					end
				else
					ui.addPopup(10, 0, "<p align='center'>Sorry, the user <CEP>"..(answer).."</CEP> is invalid or does not exist.", playerName, 250, 180, 300, true)
				end
			else
				ui.addPopup(10, 0,
				string.format("<p align='center'>You have to wait %ds in order to start a new trade.", ((room.player[playerName].trade.timestamp + 15000)-os.time())/1000), playerName, 250, 180, 300, true)
			end
		elseif popupId == 11 then
			if answer == "yes" then
				room.player[playerName].trade.isActive = true
				room.player[room.player[playerName].trade.whom].trade.isActive = true
				
				ui.addTextArea (1002, "<b><font face='Consolas'><p align='right'><CEP>Trading with</CEP> <D>"..(room.player[playerName].trade.whom).."</D>", playerName, 600, 20, 200, 0, 0x000000, 0x000000, 1.0, true)
				ui.addTextArea (1002, "<b><font face='Consolas'><p align='right'><CEP>Trading with</CEP> <D>"..(playerName).."</D>", room.player[playerName].trade.whom, 600, 20, 200, 0, 0x000000, 0x000000, 1.0, true)
			elseif answer == "no" then
				ui.addPopup(10, 0, "<p align='center'><D>"..(playerName).."</D> has <R>rejected</R> the trade.", room.player[playerName].trade.whom, 250, 180, 300, true)
				eventPopupAnswer(11, playerName, "CANCEL")
			elseif answer == "canceled" then
				ui.addPopup(10, 0, "<p align='center'><D>"..(playerName).."</D> has <CEP>canceled</CEP> the trade.", room.player[playerName].trade.whom, 250, 180, 300, true)
				ui.addPopup(10, 0, "<p align='center'>Trade has been canceled successfully.", playerName, 250, 180, 300, true)
				ui.removeTextArea(1002, room.player[playerName].trade.whom)
				ui.removeTextArea(1002, playerName)
				
				eventPopupAnswer(11, playerName, "CANCEL")
			end
			
			if answer == "CANCEL" then
				playerCancelTrade(room.player[room.player[playerName].trade.whom])
				playerCancelTrade(room.player[playerName])
			end
		end
	end]]
end)


onEvent("NewGame", function()
	if timer <= 10000 then
		generateBoundGrounds()
		tfm.exec.setGameTime(0)
		ui.setMapName(modulo.name)
		setWorldGravity(0, 0)
		
		for name, _ in next, tfm.get.room.playerList do
			eventNewPlayer(name)
			eventPlayerRespawn(name)
		end
	else
		--appendEvent(3100, tfm.exec.newGame, xmlLoad)
		error("New map loaded.")
	end
end)