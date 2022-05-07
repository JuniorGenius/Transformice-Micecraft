local main = function()	
  do
    ui.addTextArea(999,
      "<font size='16' face='Consolas' color='#ffffff'><p align='left'>Initializing...</p></font>", nil,
      55, 320,
      690, 0,
      0x000000,
      0x000000,
      1.0, true
    )
    modulo.loading = true
  
    --local scl = 0.8
    modulo.loadImg[2] = {
      tfm.exec.addImage(modulo.sprite, "~777", 70, 50, nil, 1.0, 1.0, 0, 1.0, 0, 0),
      tfm.exec.addImage(modulo.loadImg[1][1], ":42", 0, 0, nil, 1.0, 1.0, 0, 1.0, 0, 0),
      tfm.exec.addImage(modulo.loadImg[1][2], ":69", 55, 348, nil, 1.0, 1.0, 0, 1.0, 0, 0)
    }
    
    tfm.exec.setGameTime(0)
    ui.setMapName(modulo.name) 
  end
  
	for i=0, 512 do
		if not objectMetadata[i] then objectMetadata[i] = {} end
		local _ref = objectMetadata[i] 
		objectMetadata[i] = {
			name = _ref.name or "Null",
			drop = _ref.drop or 0,
			durability = _ref.durability or 18,
			glow = _ref.glow or 0,
			translucent = _ref.translucent or false,
			sprite = _ref.sprite or "17e1315385d.png",
			particles = _ref.particles or {},
			interact = _ref.interact or false,
			
			handle = _ref.handle,
			
			onCreate = _ref.onCreate or dummyFunc,
			onPlacement = _ref.onPlacement or dummyFunc,
			onDestroy = _ref.onDestroy or dummyFunc,
			onInteract = _ref.onInteract or dummyFunc,
			onHit = _ref.onHit or dummyFunc,
			onDamage = _ref.onDamage or dummyFunc,
			onContact = _ref.onContact or dummyFunc,
			onUpdate = _ref.onUpdate or dummyFunc,
			onAwait = _ref.onAwait or dummyFunc
		}
	end
	
	do
		tfm.exec.disableAfkDeath(true)
		tfm.exec.disableAutoNewGame(true)
		tfm.exec.disableAutoScore(true)
		tfm.exec.disableAutoShaman(true)
		tfm.exec.disableAutoTimeLeft(true)
		tfm.exec.disablePhysicalConsumables(true)
		tfm.exec.disableWatchCommand(true)
		
		system.disableChatCommandDisplay(nil)
		
		
		if not room.isTribe then
			tfm.exec.setRoomMaxPlayers(7)
			tfm.exec.setPlayerSync(nil) 
			tfm.exec.disableDebugCommand(true)
		end
	end
	
	map.seed = (os.time() or 42069777777)
	math.randomseed(map.seed)
	local heightMaps = {}
	
	for i=1, 7 do
		heightMaps[i] = generatePerlinHeightMap(
			nil, -- Seed
			i==1 and 30 or 20, -- Amplitude
			i==1 and 24 or 12, -- Wave Length
			i==1 and 64 or 60-((i-1)*20), -- Surface Start
			1020, -- Width
			i==1 and 128 or 140-((i-1)*20)
		)
		map.heightMaps[i] = heightMaps[i]
	end
	createNewWorld(heightMaps) -- newMap
	
	tfm.exec.newGame(xmlLoad)
end

require("resources")

xpcall(main, errorHandler)