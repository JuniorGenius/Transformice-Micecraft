itemReturnDisplayPositions = function(self, playerName)
	local player = room.player[playerName]
	local dx, dy
	
	if type(self.dx) == "number" then
		dx = self.dx
	else
		if player.inventory.interaction.crafting then
			dx = self.dx.craft[player.inventory.interaction.crafting]
		elseif player.inventory.interaction.furnacing then
			dx = self.dx.furnace
		end
	end
	
	if type(self.dy) == "number" then
		dy = self.dy
	else
		if player.inventory.interaction.crafting then
			dy = self.dy.craft[player.inventory.interaction.crafting]
		elseif player.inventory.interaction.furnacing then
			dy = self.dy.furnace
		end
	end
	
	return dx, dy
end

itemDisplay = function(self, playerName, onInventoryBar)
	if self.sprite[2] then tfm.exec.removeImage(self.sprite[2]) end
	
	local dx, dy = itemReturnDisplayPositions(self, playerName)
	local scale = (self.id == 110 and (room.player[playerName].inventory.interaction.crafting == 9 and 1.5 or 1.0) or 1.0)
	dy = dy + (onInventoryBar and 34 or 0)
	local _ui_addTextArea, _ui_removeTextArea = ui.addTextArea, ui.removeTextArea
	
	if self.itemId ~= 0 then
		self.sprite[2] = tfm.exec.addImage(
			self.sprite[1],
			":"..(self.id+10),
			dx, dy,
			playerName,
			scale/1.8823, scale/1.8823,
			0, 1.0,
			0, 0
		)
		
		if self.stackable then
			_ui_addTextArea(
				self.id+60,
				string.format("<p align='center'><font size='"..(13*scale).."'><VP><b>%d", self.amount),
				playerName,
				dx-(9*scale), dy,
				34*scale, 0,
				0x000000, 0x000000,
				1.0, true
			)
		else
			_ui_removeTextArea(self.id+60, playerName)
		end
	else
		self.sprite[2] = nil
		_ui_removeTextArea(self.id+60, playerName)
	end
	
	_ui_addTextArea(
		self.id+110,
		"<textformat leftmargin='1' rightmargin='1'><a href='event:"..(self.id > 100 and "interaction" or "inventory").."'>\n\n\n\n\n\n\n\n\n\n\n\n", 
		playerName, 
		dx - (10*scale), dy - (10*scale), --350
		37*scale, 32*scale, 
		0x000001, 0x000001, 
		0, true
	)
	
	return {dx, dy}
end

itemHide = function(self, playerName)
	if self.sprite[2] then tfm.exec.removeImage(self.sprite[2]) end
	self.sprite[2] = nil
	
	ui.removeTextArea(self.id+60, playerName)
	ui.removeTextArea(self.id+110, playerName)
end