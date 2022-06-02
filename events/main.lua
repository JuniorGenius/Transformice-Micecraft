onEvent("LoadFinished", function()
	modulo.loading = false
  
	ui.removeTextArea(999, nil)
	ui.removeTextArea(1001, nil)
	for _, img in next, modulo.loadImg[2] do
		tfm.exec.removeImage(img, true)
	end
	
	if modulo.bar then tfm.exec.removeImage(modulo.bar) end
	
	setWorldGravity(0, 10)
	
	
	for playerName, Player in next, room.player do
		setUserInterface(playerName)
	end
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
		Player:actualizeInfo(map.spawnPoint.x, map.spawnPoint.y, _, _, true, true)
	end
end)

onEvent("NewPlayer", function(playerName)
	startPlayer(playerName, map.spawnPoint)
	local lang = room.player[playerName].language
	
	if not modulo.loading then
		setUserInterface(playerName)
	end
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
	commandHandle(command, playerName)
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
				room.player[room.player[playerName].trade.whom]:cancelTrade()
				Player:cancelTrade()
			end
		end
	end]]
end)

onEvent("NewGame", function()
	if os.time() >= room.timestamp + 3000 then
		if room.rcount <= 5 then
			if room.rcount > 0 then
				tfm.exec.chatMessage(("<b><R>WARNING !</R> <CEP>Illegal map load detected. Please do not load maps. (%d/5)</CEP></b>"):format(room.rcount))
				appendEvent(3500, false, function(xml)
					tfm.exec.newGame(xml)
					initWorld()
				end, xmlLoad)	
			else
				initWorld()
			end
		else
			error("New map loaded.")
		end
	end
end)

require("Chunk")