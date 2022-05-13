playerNew = function(playerName, spawnPoint)
	local tfmp = tfm.get.room.playerList[playerName]
	map.userHandle[playerName] = true
	local gChunk = getPosChunk(spawnPoint.x, spawnPoint.y)
	
	local self = {
		name = playerName,
		x = tfmp.x or 16320,
		y = tfmp.y or 3000,
		tx = 0,
		ty = 0,
		id = tfmp.id,
		spawnPoint = {
			x = spawnPoint and spawnPoint.x or 16320,
			y = spawnPoint and spawnPoint.y or 3000
		},
		vx = tfmp.vx or 0,
		vy = tfmp.vy or 0,
		facingRight = tfmp.facingRight or true,
		isAlive = false,
		currentChunk = gChunk or 342,
		lastChunk = gChunk,
		lastActiveChunk = gChunk,
		timestamp = os.time(),
		static = 0,
		language = tfmp.language,
		
		showDebug = false,
		withinRange = nil,
		
		mouseBind = {
			delay = 175,
			timestamp = 0
		},
		
		windowHandle = {
			delay = 300,
			timestamp = 0
		},
		
		keys = {},
		
		inventory = {
			bag = stackNew(27, playerName,
				stackPresets["playerBag"], 0, "bag"),
			invbar = stackNew(9, playerName,
				stackPresets["playerInvBar"], 27, "invbar"),
			craft = stackNew(5, playerName,
				stackPresets["playerCraft"], 36, "craft"),
			armor = stackNew(5, playerName,
				stackPresets["playerArmor"], 41, "armor"),
			selectedSlot = nil,
			holdingSprite = nil,
			slotSprite = nil,
			owner = playerName,
			barActive = false,
			displaying = false,
			timestamp = 0,
			delay = 400
		},
		
		alert = {
			text = nil,
			timestamp = 0,
			await = 1500,
			id = -1
		},
		
		trade = {
			whom = nil,
			isActive = false,
			timestamp = 0 
		}
	}
	
	return self
end