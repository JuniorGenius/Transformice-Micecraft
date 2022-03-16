local eventLoadFinished = function()
	ui.removeTextArea(999, nil)
	tfm.exec.removeImage(modulo.loading)
	modulo.loading = nil
	tfm.exec.setWorldGravity(0, 10)
	--ui.addTextArea(777, "", nil, 0, 25, 300, 100, 0x000000, 0x000000, 1.0, true)
end

function eventLoop(elapsed, remaining)
	local _os_time = os.time

	if modulo.loading then
		if timer < awaitTime then
			ui.updateTextArea(999, string.format("<font size='48'><p align='center'><D><font face='Wingdings' size='64'>6</font>\n%s</D></p></font>", ({'.', '..', '...'})[((timer/500)%3)+1]), nil) -- Finishing
		else
			eventLoadFinished()
		end
	end
	
	do
		if timer > 10000 and modulo.loading then
			error("Script loading failed.", 2)
		else
			for _, player in next, room.player do
				if player.isAlive then
					playerActualizeInfo(player)
					
					playerReachNearChunks(player)
					
					if modulo.loading then
						if map.chunk[player.currentChunk].activated then
							awaitTime = -1000
						else
							if timer >= awaitTime - 1000 then
								awaitTime = awaitTime + 500
							end
						end
					end
					
					if player.static and _os_time() > player.static then
						playerStatic(player, false)
					end
				end
				
				playerCleanAlert(player)
			end
		
			if _os_time() > map.timestamp + 4000 then
				if modulo.runtimeLapse > 1 then
					print("<R><b>Runtime reset:</b> <D>" .. modulo.runtimeLapse)
				end
				modulo.runtimeLapse = 0
			end
			
			do
				if modulo.runtimeLapse < modulo.runtimeLimit then
					handleChunksRefreshing()
				end
				
				if modulo.runtimeLapse >= modulo.runtimeLimit then
					for _, player in next, room.player do
						if not player.static then
							playerStatic(player, true)
							playerAlert(player, "<b>Module Timeout", nil, "CEP", 48, 3900)
						end
					end
				end

			end
			--[[if tt >= 3 then
				map.loadingTotalTime = map.loadingTotalTime + tt
				map.totalLoads = map.totalLoads + 1
				map.loadingAverageTime = _math_round(map.loadingTotalTime / map.totalLoads, 2)
				if room.isTribe then
					local color
					if tt < 10 then color = "VP" elseif tt >= 10 and tt < 20 then color = "CEP" else color = "R" end
					print(string.format("<V>[Event Loop]</V> Chunks updated in <%s>%d ms</%s> (avg. %f ms)", color, tt, color, map.loadingAverageTime))
				end
			end]]
		end
	end
	
	if globalGrounds > 512 then
		--print("<CEP> Warning! <R>" .. globalGrounds .. "</R> is above the safe physic objects count!")--worldRefreshChunks()
		if globalGrounds >= 712 then -- 512
			error(string.format("Physic system destroyed: <CEP>Limit of physic objects reached:</CEP> <R>%d/512", globalGrounds), 2)
		end
	end
	
	timer = timer + 500
end

function eventKeyboard(playerName, key, down, x, y)
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
end

function eventMouse(playerName, x, y)
	if timer > awaitTime and room.player[playerName] then
		if room.player[playerName].isAlive then
			if (x >= 0 and x < 32640) and (y >= 200 and y < 8392) then
				local isKeyActive = room.player[playerName].keys
				if isKeyActive[19] then -- debug
					local block = getPosBlock(x, y-200)
					if isKeyActive[18] then
						printt(map.chunk[block.chunk].grounds[1][block.act])
					else
						printt(block)
					end
				elseif isKeyActive[18] then
					playerBlockInteract(room.player[playerName], getPosBlock(x, y-200))
				elseif isKeyActive[17] then
					playerPlaceBlock(room.player[playerName], x, y)
				else
					playerDestroyBlock(room.player[playerName], x, y)
				end
			end
		end
	end
end

function eventPlayerDied(playerName)
	if room.player[playerName] then
		room.player[playerName].isAlive = false
		tfm.exec.respawnPlayer(playerName)
	end
end

function eventPlayerRespawn(playerName)
	if room.player[playerName] then
		tfm.exec.movePlayer(playerName, map.spawnPoint.x, map.spawnPoint.y, false, 0, -8)
		playerActualizeInfo(room.player[playerName], map.spawnPoint.x, map.spawnPoint.y, _, _, true, true)
	end
end

function eventNewPlayer(playerName)
	startPlayer(playerName, map.spawnPoint)
	tfm.exec.addImage("17e464d1bd5.png", "?512", 0, 8, playerName, 32, 32, 0, 1.0, 0, 0)
	ui.addTextArea(0, "<p align='right'><font size='18' face='Consolas'> <a href='event:help'>Help</a> ", playerName, 600, 375, 200, 25, 0x000000, 0x000000, 1.0, true)
end

function eventPlayerLeft(playerName)
	room.player[playerName] = nil
end

function eventChatCommand(playerName, command)
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
		if room.isTribe then
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
		
		if player then printt(player) end
	end
end

local eventPlayerHudInteraction = function(self)
	if self.inventory.interaction.crafting then
		
		local lookup = nil
		local k = 1
		local m = i
		local itemsList = {}
		local _table_insert = table.insert
		
		for i=1, self.inventory.interaction.crafting do
			m = i
			if self.inventory.interaction.crafting == 4 and i == 3 then
				k = k + 1
			end
			
			if lookup then
				k = k + 1
				if self.inventory.interaction[m].itemId == craftsData[lookup][1][k] then
					_table_insert(itemsList, self.inventory.interaction[m])
					if k == #craftsData[lookup][1] then
						return itemCreate(self.inventory.interaction[10], craftsData[lookup][2][1], craftsData[lookup][2][2], true), itemsList
					end
				else
					if k <= #craftsData[lookup][1] then
						lookup = nil
						k = 0
						break
					else
						return itemCreate(self.inventory.interaction[10], craftsData[lookup][2][1], craftsData[lookup][2][2], true), itemsList
					end
				end
			else
				for j, craft in next, craftsData do
					if self.inventory.interaction[m].itemId == craft[1][1] then
						lookup = j
						k = 1
						_table_insert(itemsList, self.inventory.interaction[m])
						if #craftsData[lookup][1] == 1 and i == 9 then
							return itemCreate(self.inventory.interaction[10], craftsData[lookup][2][1], craftsData[lookup][2][2], true), itemsList
						else
							break
						end
					end
				end
				

			end
		end
	elseif self.inventory.interaction.furnacing then
		return nil
	end
end

function eventTextAreaCallback(textAreaId, playerName, eventName)
	if timer > awaitTime then
		if (textAreaId > 110 and textAreaId <= 146) or (textAreaId > 210 and textAreaId <= 220) then
			local newSlot = textAreaId - 110
			local select = playerGetInventorySlot(room.player[playerName], textAreaId - 110)
			
			if room.player[playerName].keys[18] or room.player[playerName].keys[17] and textAreaId ~= 220 and select then
				local origin = playerGetInventorySlot(room.player[playerName], room.player[playerName].inventory.selectedSlot)
				if origin then
					local source, destinatary, pass
					
					if room.player[playerName].trade.isActive then
						source, destinatary = playerName, room.player[playerName].trade.whom
						pass = {source, destinatary}
						select = playerGetInventorySlot(room.player[destinatary], 1)
					else
						source, destinatary = playerName, playerName
						pass = playerName
					end
					
					if room.player[playerName].keys[18] then
						origin, select, newSlot = itemMove(origin, select, 0, pass)
					elseif room.player[playerName].keys[17] then
						local quantity = 1
						if origin.id == 110 then quantity = origin.amount end
						origin, select, newSlot = itemMove(origin, select, quantity, pass)
					end

					-- Display both items interacted with
					if (room.player[destinatary].inventory.barActive and (select.id > 27 and select.id <= 36)) or not room.player[destinatary].inventory.barActive then
						itemDisplay(select, destinatary, room.player[destinatary].inventory.barActive)
					end
					if (room.player[source].inventory.barActive and (origin.id > 27 and origin.id <= 36)) or not room.player[source].inventory.barActive  then
						itemDisplay(origin, source, room.player[source].inventory.barActive)
					end
					
					--[[if eventName == "inventory"	then
						return true
					else]]

					
					if eventName == "interaction" or origin.id > 100 or select.id > 100 then -- == 110	
						local display, remove = eventPlayerHudInteraction(room.player[source])
						if display and remove then
							if origin.id == 110 and select.id ~= origin.id then
							
								for _, element in next, remove do
									inventoryExtractItem(
										room.player[source].inventory, 
										element.itemId, 1, element
									)
									itemRemove(origin, source)
								end
							else
								itemDisplay(display, destinatary, room.player[source].inventory.barActive)
							end
						else
							itemRemove(room.player[source].inventory.interaction[10], source)
						end
					end
				end
			end
			playerChangeSlot(room.player[playerName], newSlot)
		end
	end
	
	if textAreaId == 0 then
		if eventName == "help" then
			local helpText = "<p align='center'><font size='48' face='Consolas'><D>Help</D></font></p>\n\n<font face='Consolas'>Welcome to <J><b>"..(modulo.name).."</b></J>, script created by <V>"..(modulo.creator).."</V>.\n\n<b>CONTROLS:</b>\n- <u>CLICK:</u> Damage blocks.\n- <u><V>SHIFT</V> + CLICK:</u> Places a block, from selected slot.\n- <u>[1- 9]:</u> Select a slot from inventory. You can also click on them to select.\n- [E]: Opens the main inventory.\n- <u><V>CTRL</V> + CLICK</u>:  Interacts with a block, when in inventory it exchanges the position of an item from a previous slot to the new clicked one.\n\n\nIf you find any bugs, please report to my Direct Messages in the Forum or through my Discord: <CH>Cap#1753</CH>.\n\nHope you enjoy!"
			ui.addTextArea(200, helpText, playerName, 150, 50, 500, 300, 0x010101, 0x010101, 0.67, true)
			ui.addTextArea(201, "<font size='16'><a href='event:clear'><R><b>X</b></R></a>", playerName, 630, 55, 0, 0, 0x000000, 0x000000, 1.0, true)
		end
	end
	
	if eventName == "clear" or eventName == "alert" then
		ui.removeTextArea(textAreaId, playerName)
		if textAreaId == 201 then
			ui.removeTextArea(200, playerName)
		elseif textAreaId == 1001 then
			ui.removeTextArea(1000, playerName)
		end
	end
end

function eventPopupAnswer(popupId, playerName, answer)
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
end

function eventNewGame()
	generateBoundGrounds()
	tfm.exec.setGameTime(0)
	ui.setMapName(modulo.name)
	tfm.exec.setWorldGravity(0, 0)
	
	for name, _ in next, tfm.get.room.playerList do
		eventNewPlayer(name)
		eventPlayerRespawn(name)
	end
end