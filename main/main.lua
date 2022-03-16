local main = function()	
	for i=1, 512 do
		if not blockMetadata[i] then
			blockMetadata[i] = {
				name = "Null",
				drop = 0,
				durability = 18,
				glow = 0,
				translucent = false,
				sprite = "17e1315385d.png",
				particles = {}
			}
		else
			if not blockMetadata[i].sprite then blockMetadata[i].sprite = "17e1315385d.png" end
			if blockMetadata[i].drop == 0 then blockMetadata[i].drop = i end
		end
	end
	
	do
		tfm.exec.disableAfkDeath(true)
		tfm.exec.disableAutoNewGame(true)
		tfm.exec.disableAutoScore(true)
		tfm.exec.disableAutoShaman(true)
		tfm.exec.disableAutoTimeLeft(true)
		tfm.exec.disablePhysicalConsumables(true)
		
		system.disableChatCommandDisplay(nil)
		
		
		if not room.isTribe then
			tfm.exec.setRoomMaxPlayers(8)
			tfm.exec.setPlayerSync(nil) 
			tfm.exec.disableDebugCommand(true)
		end
	end
	
	map.seed = -1881899978--os.time() or 2^31
	math.randomseed(map.seed)
	local heightMaps = {}
	
	for i=1, 7 do
		heightMaps[i] = generatePerlinHeightMap(
			nil, -- Seed
			i==1 and 30 or 20, -- Amplitude
			i==1 and 24 or 12, -- Wave Length
			i==1 and 64 or 60-((i-1)*20), -- Surface Start
			1040, -- Width
			i==1 and 128 or 140-((i-1)*20)
		)
		map.heightMaps[i] = heightMaps[i]
	end
	createNewWorld(heightMaps) -- newMap
	
	tfm.exec.newGame(xmlLoad)
end

main()

end

xpcall(game, function(err)
	ui.addTextArea(0,
		string.format(
			"<p align='center'><font size='18'><R><B><font face='Wingdings'>M</font> Fatal Error</B></R></font>\n\n<CEP>%s</CEP>\n\n<CS>%s</CS>\n\n\nSend this to Indexinel#5948",
			err, debug.traceback()
		),
		nil,
		200, 100,
		400, 200,
		0x010101, 0x010101,
		0.8, true
	)
	for n in next, _G do
		if string.find(tostring(n), "event") then
			_G[n] = function()
				return
			end
		end
	end
end)