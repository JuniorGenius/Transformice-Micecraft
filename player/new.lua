playerNew = function(playerName, spawnPoint)
	local tfmp = tfm.get.room.playerList[playerName]
	
	local self = {
		name = playerName,
		x = tfmp.x or 0,
		y = tfmp.y or 0,
		tx = 0,
		tx = 0,
		id = tfmp.id,
		spawnPoint = {
			x = spawnPoint and spawnPoint.x or math.random(200, 600),
			y = spawnPoint and spawnPoint.y or 8200
		},
		vx = tfmp.vx or 0,
		vy = tfmp.vy or 0,
		facingRight = tfmp.facingRight or true,
		isAlive = false,
		currentChunk = getPosChunk(spawnPoint.x, spawnPoint.y) or 342,
		lastChunk = getPosChunk(spawnPoint.x, spawnPoint.y),
		lastActiveChunk = getPosChunk(spawnPoint.x, spawnPoint.y),
		timestamp = os.time(),
		static = 0,
		keys = {},
		inventory = {
			slot = {},
			interaction = {
				crafting = false,
				furnacing = false
			},
			armor = {},
			selectedSlot = 1,
			slotSprite = nil,
			owner = playerName,
			barActive = false,
			displaying = false
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
	
	local _itemNew = itemNew
	for i=1, 36 do
		self.inventory.slot[i] = _itemNew(i, 0, true, 0, false)
		if i <= 10 then
			self.inventory.interaction[i] = _itemNew(100+i, 0, true, 0, true)
		end
	end
	
	return self
end