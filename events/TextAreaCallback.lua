onEvent("TextAreaCallback", function(textAreaId, playerName, eventName)
	if timer > awaitTime and room.player[playerName] then
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
						local display, remove = playerHudInteraction(room.player[source])
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
		
		if eventName == "respawn" then
			eventTextAreaCallback(textAreaId, playerName, "clear")
			tfm.exec.respawnPlayer(playerName)
		end
	end
end)

onEvent("TextAreaCallback", function(textAreaId, playerName, eventName)
	if textAreaId == 0 then
		if eventName == "help" then
			local helpText = "<p align='center'><font size='48' face='Consolas'><D>Help</D></font></p>\n\n<font face='Consolas'>Welcome to <J><b>"..(modulo.name).."</b></J>, script created by <V>"..(modulo.creator).."</V>.\n\n<b>CONTROLS:</b>\n- <u>CLICK:</u> Damage blocks.\n- <u><V>SHIFT</V> + CLICK:</u> Places a block, from selected slot.\n- <u>[1- 9]:</u> Select a slot from inventory. You can also click on them to select.\n- [E]: Opens the main inventory.\n- <u><V>CTRL</V> + CLICK</u>:  Interacts with a block, when in inventory it exchanges the position of an item from a previous slot to the new clicked one.\n\n\nIf you find any bugs, please report to my Direct Messages in the Forum or through my Discord: <CH>Cap#1753</CH>.\n\nHope you enjoy!"
			ui.addTextArea(200, helpText, playerName, 150, 50, 500, 300, 0x010101, 0x010101, 0.67, true)
			ui.addTextArea(201, "<font size='16'><a href='event:clear'><R><b>X</b></R></a>", playerName, 630, 55, 0, 0, 0x000000, 0x000000, 1.0, true)
		end
	end
end)

onEvent("TextAreaCallback", function(textAreaId, playerName, eventName)
	if eventName == "clear" or eventName == "alert" then
		ui.removeTextArea(textAreaId, playerName)
		if textAreaId == 201 then
			ui.removeTextArea(200, playerName)
		elseif textAreaId == 1001 then
			ui.removeTextArea(1000, playerName)
		end
	end
end)