onEvent("TextAreaCallback", function(textAreaId, playerName, eventName)
	if textAreaId == 0 then
		uiDisplayDefined(eventName, playerName)
	end
	
	if eventName == "respawn" then
		eventTextAreaCallback(textAreaId, playerName, "clear")
		tfm.exec.respawnPlayer(playerName)
	end
	
	if eventName:sub(1, 7) == "profile" then
		tfm.exec.chatMessage("<N>https://atelier801.com/profile?pr=%s</N>", (eventName:sub(9, -1)):gsub('#', '%%23'))
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

onEvent("TextAreaCallback", function(textAreaId, playerName, eventName)
	local Window = textAreaHandle[textAreaId]
	if Window then
		eventWindowCallback(
			Window,
			playerName,
			eventName
		)
	end
end)

onEvent("TextAreaCallback", function(textAreaId, playerName, eventName)
	local Player = room.player[playerName]
	if timer > awaitTime and Player then
		local targetStack = Player.inventory[eventName]
		if not targetStack then return end
		
		local newSlot = targetStack.slot[textAreaId - (350 + targetStack.offset)]
		local select = (newSlot)
		
		if (Player.keys[17] or Player.keys[16]) and select then
			local origin = Player.inventory.selectedSlot
			if origin then
				select, newSlot = playerMoveItem(Player, origin, select, true)
				playerHudInteract(Player, select)
			end
		end
		
		if not newSlot then
			newSlot = Player.inventory.selectedSlot
		else
			eventSlotSelected(Player, newSlot)
		end
		playerChangeSlot(Player, newSlot.stack, newSlot, true)
	end
end)