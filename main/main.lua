require("commands")

require("worlds")



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
  
	for i=0, 1024 do
		if not objectMetadata[i] then objectMetadata[i] = {} end
		local _ref = unreference(objectMetadata[i] or {}) 
		local obj = objectMetadata[i] or {}
		
		obj.name = _ref.name or "Null"
		obj.drop = _ref.drop or 0
		
		obj.glow = _ref.glow or 0

		if _ref.sprite and _ref.sprite ~= "" then
			tfm.exec.removeImage(
				tfm.exec.addImage(_ref.sprite, ":1",
					384, 484,
					nil,
					1.0, 1.0,
					0.0, 1.0,
					0.0, 0.0
				)
			)
		end
		
		if i < 512 then
			obj.sprite = _ref.sprite or "17e1315385d.png"
			obj.durability = _ref.durability or 32
			
			obj.translucent = _ref.translucent or false
			
			obj.onCreate = _ref.onCreate or dummyFunc
			obj.onPlacement = _ref.onPlacement or dummyFunc
			obj.onDestroy = _ref.onDestroy or dummyFunc
			obj.onContact = _ref.onContact or dummyFunc
			obj.placeable = true
		else
			obj.sprite = _ref.sprite or "180c452d106.png"
			
			obj.durability = _ref.durability or 0
			obj.degradable = _ref.degradable or false
			obj.ftype = obj.ftype or {[0]=1.0}
			
			obj.sharpness = _ref.sharpness or 0
			obj.strenght = _ref.strenght or 0
			obj.placeable = false
		end
		obj.particles = _ref.particles or {1}
		obj.interact = _ref.interact or false
			
		obj.handle = _ref.handle
			
		obj.onInteract = _ref.onInteract or dummyFunc
		obj.onHit = _ref.onHit or dummyFunc
		obj.onDamage = _ref.onDamage or dummyFunc
		
		obj.onUpdate = _ref.onUpdate or dummyFunc
		obj.onAwait = _ref.onAwait or dummyFunc
		obj.hardness = _ref.hardness or 0
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
			tfm.exec.setRoomMaxPlayers(modulo.maxPlayers)
			tfm.exec.setPlayerSync(nil) 
			tfm.exec.disableDebugCommand(true)
		end
	end
	
	map.seed = (os.time() or 42069777777)
	math.randomseed(map.seed)
	
	do
		generateNewWorld(
			worldHeight, worldWidth,
			worldPresets[modulo.gameMode] or worldPresets["overworld"]
		)
		
		createNewWorld()
	end
	
	for name, _ in next, tfm.get.room.playerList do
		eventNewPlayer(name)
	end
	
	tfm.exec.newGame(xmlLoad)
end

require("resources")

xpcall(main, errorHandler)