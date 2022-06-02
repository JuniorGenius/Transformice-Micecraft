
function _Player.new(playerName, spawnPoint)
	local self = setmetatable({}, _Player)
	local tfmp = tfm.get.room.playerList[playerName]
	
	map.userHandle[playerName] = true
	local gChunk = getPosChunk(spawnPoint.x, spawnPoint.y)
	
	self.name = playerName
	self.x = tfmp.x or worldRightEdge/2
	self.y = tfmp.y or worldLowerEdge/2
	self.tx = 0
	self.ty = 0
	self.id = tfmp.id
	self.spawnPoint = {
		x = spawnPoint and spawnPoint.x or worldRightEdge/2,
		y = spawnPoint and spawnPoint.y or worldLowerEdge/2
	}
	self.vx = tfmp.vx or 0
	self.vy = tfmp.vy or 0
	self.facingRight = tfmp.facingRight or true
	self.isAlive = false
	self.currentChunk = gChunk or worldChunks / 2
	self.lastChunk = gChunk
	self.lastActiveChunk = gChunk
	self.timestamp = os.time()
	self.staticState = 0
	self.language = tfmp.language
		
	self.showDebug = false
	self.withinRange = nil
	
	self.prange = 80
		
	self.mouseBind = {
		delay = 175,
		timestamp = 0
	}
		
	self.windowHandle = {
		delay = 300,
		timestamp = 0
	}
		
	self.keys = {}
		
	self.inventory = {
		bag = _Stack.new(27, playerName,
			stackPresets["playerBag"], 0, "bag"),
		invbar = _Stack.new(9, playerName,
			stackPresets["playerInvBar"], 27, "invbar"),
		craft = _Stack.new(5, playerName,
			stackPresets["playerCraft"], 36, "craft"),
		armor = _Stack.new(5, playerName,
			stackPresets["playerArmor"], 41, "armor"),
		selectedSlot = nil,
		holdingSprite = nil,
		slotSprite = nil,
		owner = playerName,
		barActive = false,
		displaying = false,
		timestamp = 0,
		delay = 400
	}
		
	self.alert = {
		text = nil,
		timestamp = 0,
		await = 1500,
		id = -1
	}
		
	self.trade = {
		whom = nil,
		isActive = false,
		timestamp = 0 
	}
	
	return self
end