setUserInterface = function(playerName)
	local Player = room.player[playerName]
	local lang = Player.language
	ui.addTextArea(0,
		("<p align='right'><font size='12' color='#ffffff' face='Consolas'><a href='event:credits'>%s</a> &lt;\n <a href='event:reports'>%s</a> &lt;\n <a href='event:controls'>%s</a> &lt;\n <a href='event:help'>%s</a> &lt;\n"):format(
		translate("credits title", lang),
		translate("reports title", lang),
		translate("controls title", lang),
		translate("help title", lang)
	),
	playerName, 700, 330, 100, 70, 0x000000, 0x000000, 1.0, true)

	if Player then
		Player:displayInventoryBar()
		Player:changeSlot("invbar", 1)
		
		do
			if Player.background then
				_tfm_exec_removeImage(Player.background)
			end
			Player.background = _tfm_exec_addImage("17e464d1bd5.png", "?512", 0, 8, playerName, 32, 32, 0, 1.0, 0, 0)
		end
	end
end