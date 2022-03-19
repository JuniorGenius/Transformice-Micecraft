onEvent("LoadFinished", function()
  modulo.loading = false
  
	ui.removeTextArea(999, nil)
  for _, img in next, modulo.loadImg[2] do
    tfm.exec.removeImage(img)
  end

	tfm.exec.setWorldGravity(0, 10)
	--ui.addTextArea(777, "", nil, 0, 25, 300, 100, 0x000000, 0x000000, 1.0, true)
end)


require("Loop")

onEvent("Keyboard", function(playerName, key, down, x, y)
	if timer > awaitTime and room.player[playerName] then
		if down then
			room.player[playerName].keys[key+1] = true
			
			if (key >= 49 and key <= 57) or (key >= 97 and key <= 105) then
				playerChangeSlot(room.player[playerName], 27 + (key - (key <= 57 and 48 or 96)))
			end
			
			if key == 72 then -- H
				eventTextAreaCallback(0, playerName, "help")
			elseif key == 46 then -- delete
				local item = playerGetInventorySlot(room.player[playerName], room.player[playerName].inventory.selectedSlot)
				if item then itemRemove(item, playerName) end
			elseif key == 69 then -- E
				if room.player[playerName].inventory.displaying then
					playerHideInventory(room.player[playerName])
				else
					playerDisplayInventory(room.player[playerName], "inventory")
				end
			elseif key == 71 then -- G
				if room.player[playerName].trade.isActive then 
					eventPopupAnswer(11, playerName, "canceled")
				else
					ui.addPopup(10, 0, "<p align='center'>Tradings are disabled currently, sorry.</p>"--[[Type the name of whoever you want to trade with."]], playerName, 250, 180, 300, true)
				end
			end
		else
			room.player[playerName].keys[key+1] = false
		end
		
		if room.player[playerName] and timer > awaitTime then
			if room.player[playerName].isAlive then playerActualizeInfo(room.player[playerName], x, y, _, _, key < 4 and (key%2==0 and key==2 or nil) or nil) end
		end
	end
end)

onEvent("Mouse", function(playerName, x, y)
	if timer > awaitTime and room.player[playerName] then
		if room.player[playerName].isAlive then
			if (x >= 0 and x < 32640) and (y >= 200 and y < 8392) then
				local block = getPosBlock(x, y-200)
				local isKeyActive = room.player[playerName].keys
				if isKeyActive[19] then -- debug
					if isKeyActive[18] then
						printt(map.chunk[block.chunk].grounds[1][block.act])
					else
						printt(block)
					end
				elseif isKeyActive[18] then
					playerBlockInteract(room.player[playerName], getPosBlock(x, y-200))
				elseif isKeyActive[17] then
					playerPlaceObject(room.player[playerName], x, y, isKeyActive[33])
				else
					if block.id ~= 0 then
						playerDestroyBlock(room.player[playerName], x, y)
					else
						room.player[playerName].inventory.slot[room.player[playerName].inventory.selectedSlot]:onHit(x, y)
					end
				end
			end
		end
	end
end)

onEvent("PlayerDied", function(playerName, override)
	if room.player[playerName] then
		room.player[playerName].isAlive = false
		if override then
			tfm.exec.respawnPlayer(playerName)
		else
			ui.addTextArea(42069, "\n\n\n\n\n\n\n\n<p align='center'><font face='Soopafresh' size='42'><R>You've died.</R></font>\n\n\n<font size='28' face='Consolas' color='#ffffff'><a href='event:respawn'>Respawn</a></font></p>", playerName, 0, 0, 800, 400, 0x010101, 0x010101, 0.4, true)
		end
	end
end)

onEvent("PlayerRespawn", function(playerName)
	if room.player[playerName] then
		tfm.exec.movePlayer(playerName, map.spawnPoint.x, map.spawnPoint.y, false, 0, -8)
		playerActualizeInfo(room.player[playerName], map.spawnPoint.x, map.spawnPoint.y, _, _, true, true)
	end
end)

onEvent("NewPlayer", function(playerName)
	startPlayer(playerName, map.spawnPoint)
	tfm.exec.addImage("17e464d1bd5.png", "?512", 0, 8, playerName, 32, 32, 0, 1.0, 0, 0)
	ui.addTextArea(0, "<p align='right'><font size='18' face='Consolas'> <a href='event:help'>Help</a> ", playerName, 600, 375, 200, 25, 0x000000, 0x000000, 1.0, true)
end)

onEvent("PlayerLeft", function(playerName)
	room.player[playerName] = nil
end)

onEvent("ChatCommand", function(playerName, command)
	local args = {}
	
	for arg in command:gmatch("%S+") do
		args[#args+1] = arg
	end
	command = args[1]
	
	if args[1] == "help" then
		eventTextAreaCallback(0, playerName, "help")
	elseif args[1] == "seed" then
		ui.addPopup(169, 0, string.format("<p align='center'>World's seed:\n%d", map.seed), playerName, 300, 180, 200, true)
	elseif args[1] == "tp" then
		if room.isTribe or playerName == modulo.creator then
			local pa = tonumber(args[2])
			local pb = tonumber(args[3])
			
			local withinRange = function(a, b) return (a >= 0 and a <= 32640) and (b >= 0 and b <= 8392) end
			
			if pa and pb then
				if withinRange(pa, pb) then tfm.exec.movePlayer(playerName, pa, pb) end
			elseif not pa or not pb then
				local pl = room.player[ args[2] ]
				if pl then
					if pl.isAlive then
						pa = pl.x
						pb = pl.y
						if withinRange(pa, pb) then tfm.exec.movePlayer(playerName, pa, pb) end
					end
				end
			end
		end
	elseif args[1] == "debug" then
		local player = room.player[args[2]]
		
		if player then printt(player, {"keys", "slot", "interaction"}) end
  elseif args[1] == "announce" or "chatannounce" then
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
	end
end)


require("TextAreaCallback")

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
	generateBoundGrounds()
	tfm.exec.setGameTime(0)
	ui.setMapName(modulo.name)
	tfm.exec.setWorldGravity(0, 0)
	
	for name, _ in next, tfm.get.room.playerList do
		eventNewPlayer(name)
		eventPlayerRespawn(name)
	end
end)