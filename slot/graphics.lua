
function _Slot:display(playerName, xOffset, yOffset)
	-- Add to display durability of the object
	if self.sprite[2] then tfm.exec.removeImage(self.sprite[2]) end
	
	local scale = self.size / 32
	local div = self.itemId < 512 and 1.8823 or 1.17647
	local doff = math.floor(4.251 * div)
	local dsp = self.itemId < 512 and 0 or 3
	local dx = self.dx + (xOffset or 0) + (doff*scale)
	local dy = self.dy + (yOffset or 0) + (doff*scale)

	local _ui_addTextArea, _ui_removeTextArea = ui.addTextArea, ui.removeTextArea
	
	if self.itemId ~= 0 then
		self.sprite[2] = tfm.exec.addImage(
			self.sprite[1],
			"~"..(self.id+100),
			dx-dsp, dy-dsp,
			playerName,
			scale/div, scale/div,
			0, 1.0,
			0, 0
		)
		
		if self.stackable and self.amount ~= 1 then
			local text = "<p align='center'><font face='Consolas' size='"..(12.4*scale).."'>" .. self.amount
			local xpos = dx-(9*scale)
			local scl = 34*scale
			_ui_addTextArea(self.id+500, "<font color='#000000'><b>" .. text, playerName, xpos+1, dy+1, scl, 0, 0x000000, 0x000000, 1.0, true)
			_ui_addTextArea(self.id+650, "<VP>" .. text, playerName, xpos, dy, scl, 0,	0x000000, 0x000000,	1.0, true)
		else
			_ui_removeTextArea(self.id+500, playerName)
			_ui_removeTextArea(self.id+650, playerName)
		end
	else
		self.sprite[2] = nil
		_ui_removeTextArea(self.id+500, playerName)
		_ui_removeTextArea(self.id+650, playerName)
	end
	
	_ui_addTextArea(
		self.id+350,
		"<textformat leftmargin='1' rightmargin='1'><a href='event:"..self.stack.."'>\n\n\n\n\n\n\n\n\n\n\n\n</a></textformat>", 
		playerName, 
		self.dx + (xOffset or 0) - (1*scale), self.dy + (yOffset or 0) - (1*scale), --350
		32*scale, 32*scale, 
		0x000000, 0x000000, 
		0, true
	)
	
	return {dx, dy}
end

function _Slot:hide(playerName)
	if self.sprite[2] then
		tfm.exec.removeImage(self.sprite[2])
		self.sprite[2] = nil
	end
	
	local _ui_removeTextArea = ui.removeTextArea
	_ui_removeTextArea(self.id+350, playerName)
	_ui_removeTextArea(self.id+500, playerName)
	_ui_removeTextArea(self.id+650, playerName)
end

function _Slot:refresh(playerName, xOffset, yOffset)
	self:hide(playerName)
	self:display(playerName, xOffset, yOffset)
end