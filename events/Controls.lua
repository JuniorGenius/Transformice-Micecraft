onEvent("Mouse", function(playerName, x, y)
	local Player = room.player[playerName]
	if timer > awaitTime and Player then
		if Player.isAlive and os.time() > Player.mouseBind.timestamp then
			if withinRange(x, y) then
				local yr =  y - worldVerticalOffset
				local block = getPosBlock(x, yr)
				local isKeyActive = Player.keys
				if isKeyActive[18] then -- debug
					if isKeyActive[17] then
						printt(map.chunk[block.chunk].grounds[1][block.act])
					else
						printt(block)
					end
				elseif isKeyActive[17] then
					Player:blockInteract(getPosBlock(x, yr))
				elseif isKeyActive[16] then
					Player:placeObject(x, y, isKeyActive[32])
				else
					if block.id ~= 0 then
						Player:destroyBlock(x, y)
					else
						Player.inventory.selectedSlot.object:onHit(x, y)
					end
				end
			end
            
            Player.mouseBind.timestamp = os.time() + Player.mouseBind.delay
		end
	end
end)

onEvent("Keyboard", function(playerName, key, down, x, y, vx, vy)
	local Player = room.player[playerName]
	if timer > awaitTime and Player then
		local isKeyActive = Player.keys

		if down then
			isKeyActive[key] = true
			
			if isKeyActive[72] then -- H
				local typedef
				if key == 72 then
					typedef = "help"
				elseif key == 75 then -- K
					typedef = "controls"
				elseif key == 82 then -- R
					typedef = "reports"
				elseif key == 67 then -- C
					typdef = "credits"
				end
				
				if typedef then
                    if os.time() > Player.windowHandle.timestamp then
                        uiDisplayDefined(typedef, playerName)
                    end
				end
			end
			
			-- Don't use Z / Q / S / D / W / A 
			local Slot = Player.inventory.selectedSlot
			if key == 46 or key == 88 then -- delete/x
				if Slot then
					Slot:empty(playerName)
				end
			elseif key == 76 then -- L
				Player:inventoryExtract(Slot.itemId, 1, Slot.stack, Slot)
				local offset = 0
				if Player.inventory.displaying then
					if Slot.stack == "invbar" then
						offset = -36
					end
				end
				
				Slot:refresh(Player.name, 0, offset)
			elseif key == 69 then -- E
                if os.time() > Player.inventory.timestamp then
                    if Player.inventory.displaying then
                        Player:hideInventory()
                        Player:displayInventoryBar()
                    else
                        Player:displayInventory(
                            {{"bag", 0, 0, true}, 
                            {"invbar", 0, -36, false}, 
                            {"craft", 0, 0, true}, 
                            {"armor", 0, 0, true}}
                        )
                    end
                    Player.inventory.timestamp = os.time() + Player.inventory.delay
                end
			elseif key == 71 then -- G
				if Player.trade.isActive then 
					eventPopupAnswer(11, playerName, "canceled")
				else
					ui.addPopup(10, 0, "<p align='center'>Tradings are disabled currently, sorry.</p>"--[[Type the name of whoever you want to trade with."]], playerName, 250, 180, 300, true)
				end
			elseif key == 86 then
				Player.showDebug = (not Player.showDebug)
				
				if Player.showDebug then
					ui.addTextArea(777, "", playerName, 5, 25, 150, 0, 0x000000, 0x000000, 1.0, true)
					ui.addTextArea(778, "", playerName, 645, 25, 150, 0, 0x000000, 0x000000, 1.0, true)
				else
					ui.removeTextArea(777, playerName)
					ui.removeTextArea(778, playerName)
				end
			end
			
			if (key >= 49 and key <= 57) or (key >= 97 and key <= 105) then
				local slotNum = key - (key <= 57 and 48 or 96)
				Player:changeSlot("invbar", slotNum, (not Player.onWindow))
			end
			
			if key == 16 or key == 17 then
				local scale = 1.5
				if Player.withinRange then
					tfm.exec.removeImage(Player.withinRange)
				end
				
				Player.withinRange = _tfm_exec_addImage(
					"1809609266a.png", "$"..playerName,
					0, 0,
					playerName,
					scale, scale,
					0.0, 1.0,
					0.5, 0.5
				)
			end
			
			if key == 27 then
				if Player.onWindow then
					uiRemoveWindow(Player.onWindow, playerName)
				end
				
				if Player.inventory.displaying then
					Player:displayInventoryBar()
				end
			end
		else -- Release
			isKeyActive[key] = false
			
			if key == 16 or key == 17 then
				if Player.withinRange then
					_tfm_exec_removeImage(Player.withinRange)
					Player.withinRange = nil
				end
			end
		end
		
		if timer > awaitTime then
			local facingRight
			if key < 4 and key%2 == 0 then
				facingRight = key == 2
			end
			
			if Player.isAlive then
				Player:actualizeInfo(x, y, vx, vy, facingRight)
			end
		end
	end
end)