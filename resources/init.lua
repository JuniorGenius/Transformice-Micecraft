local string = string
local math = math
local table = table

local system = system
local tfm = tfm
local ui = ui

local globalGrounds = 0
local groundsLimit = 1024

-- Definition of world's handling variables
-- Block:
local blockSize = 32
local blockHalf = blockSize / 2

-- Chunk:
local chunkWidth = 17
local chunkHeight = 17
local chunkSize = chunkWidth*chunkHeight
local chunkLines = 15
local chunkRows = 60

-- World:
local worldHeight = chunkHeight * chunkLines --= 255
local worldWidth = chunkWidth * chunkRows --= 1020
local worldSize = worldHeight * worldWidth --= 260 100
local worldChunks = worldSize / chunkSize

local worldPixelWidth = worldWidth * blockSize
local worldPixelHeight = worldHeight * blockSize

local worldHorizontalOffset = 0
local worldVerticalOffset = 200

local worldLeftEdge = worldHorizontalOffset -- 0
local worldRightEdge = worldLeftEdge + (worldPixelWidth) -- 32 640

local worldUpperEdge = worldVerticalOffset
local worldLowerEdge = worldUpperEdge + (worldPixelHeight)



local timer = 0
local awaitTime = 3000

local xmlLoad = '<C><P Ca="" H="%d" L="%d" /><Z><S></S><D><DS X="%d" Y="%d" /></D><O /></Z></C>'

local dummyFunc = function(...) end
local _ = nil

local room = {
	totalPlayers = 0,
	isTribe = (string.sub(tfm.get.room.name, 1, 2) == "*\003"),
	setMode = string.match(tfm.get.room.name, "micecraft%A+([_%a]+)"),
	runtimeMax = 0,
	language = tfm.get.room.language,
	player = {},
	rcount = 0,
	timestamp = 0
}

local modulo = {
	creator = "Indexinel#5948",
	discreator = "Cap#1753",
	name = "Micecraft",
	loading = true,
	loadImg = {
		[1] = {"17f94a1608c.png", "17f94a1cb39.png"},
		[2] = {}
	},
	sprite = "17f949fcbb4.png",
	runtimeLapse = 0,
	runtimeMax = 0,
	runtimeLimit = 0,
	maxPlayers = 5,
	count = 0,
	updatePercentage = function(self, limit, text)
		local percentage = self.count/(limit/100)
		ui.updateTextArea(999, string.format("<p align='left'><font size='16' face='Consolas' color='#ffffff'>%s\t<D>%0.2f%%</D></font></p>", text or "", math.ceil(percentage*100)/100))
		
		if self.bar then
			tfm.exec.removeImage(self.bar)
		end
		self.bar = tfm.exec.addImage("17d441f9c0f.png", "~1", 60, 375, nil, 1.1, (34/limit)*self.count, math.rad(270), 1.0, 0, 0)
		self.count = self.count + 1
	end,
	timeout = false,
	apiVersion = "0.28",
	tfmVersion = "8.02",
	lastest = "--@lastest",
	gameMode = (tfm.get.room.name):match("^%p-#micecraft%A+([%a_]+)") or "overworld"
}

local admin = {
	[modulo.creator] = true,
	["Pshy#3752"] = true,
	["Undermath#2907"] = true,
	["Drgenius#0000"] = true
}

modulo.runtimeMax = (room.isTribe and 40 or 60)
modulo.runtimeLimit = modulo.runtimeMax - (room.isTribe and 8 or 15)

local map = {
	chunk = {},
	
	chunksLoaded = 0,
	chunksActivated = 0,
	
	type = 0,
	
	background = nil,
	
	seed = 0,
	
	loadingTotalTime = 0,
	loadingAverageTime = 0,
	totalLoads = 0,
	
	windForce = 0,
	gravityForce = 10,
	
	spawnPoint = {},
	heightMaps = {},
	handle = {},
	timestamp = 0,
	userHandle = {},
	
	structures = {}
	--[[sun = {
		x = 16320,
		y = 200,---5000,
		glow = 1024--2000
	}]]
}

local commandList = {}
local uiHandle = {}
local uiResources = {}
local worldPresets = {}--[[
element = {
    type = ,
    identifier = ,
    container = ,
    multiplecont = ,
    xcent = ,
    ycent = ,
    width = ,
    height = ,
    text = ,
    event = ,
    image = ,
    remove = ,
}]]

local _Chunk = {}
_Chunk.__index = _Chunk

local _Slot = {}
_Slot.__index = _Slot

local _Stack = {}
_Stack.__index = _Stack

local _Player = {}
_Player.__index = _Player

local withinRange = function(a, b)
    return  (a >= worldLeftEdge and a <= worldRightEdge) and (b >= worldUpperEdge and b <= worldLowerEdge)
end

local event = {}
local onEvent, errorHandler, warning

warning = function(issue)
	local message = ("<R>[<b>Warning</b>]</R> <D>%s</D>"):format(issue or "(null)")
	print(message)
end

onEvent = function(eventName, callback)
	if not event[eventName] then
		event[eventName] = {}
	end
	table.insert(event[eventName], callback)
	
	event[eventName][0] = function(...)
		for i=1, #event[eventName] do
			local ok, result = pcall(event[eventName][i], ...)
			
			if not ok then
				errorHandler(result, eventName, i)
				return
			end
		end
	end
	
	_G["event" .. eventName] = function(...)
		if event then
			if event[eventName] then
				if timer ~= "error" then
					return event[eventName][0](...)
				end
			end
		end
	end
end

errorHandler = function(err, eventName, instance)
	err = err:gsub("\t", "")
	warning(("[event%s (#%d)] %s"):format(eventName or "null", instance or 0, err or "null"))
	tfm.exec.addImage("17f94a1608c.png", "~42", 0, 0, nil, 1.0, 1.0, 0, 1.0, 0, 0)
	tfm.exec.addImage("17f949fcbb4.png", "~43", 70, 120, nil, 1.0, 1.0, 0, 1.0, 0, 0)
	
	local errorMessage = string.format(
		"<p align='center'><font size='18'><R><B><font face='Wingdings'>M</font> Fatal Error</B></R></font>\n\n<CEP>%s</CEP>\n\n<CS>%s</CS>\n\n%s\n\n\n<CH>Send this to Indexinel#5948</CH></p>",
		err, debug.traceback(),
		(eventName and instance) and ("<D>Event: <V>event" .. eventName .. "</V> #" .. instance .. "</D>") or ""
	)
	
	tfm.exec.chatMessage(errorMessage, nil)
	ui.addTextArea(42069,
		errorMessage,
		nil,
		100, 50,
		600, 300,
		0x010101, 0x010101,
		0.8, true
	)

	for name, evt in next, event do
		for i=1, #evt do
			evt[i] = dummyFunc
		end
	end
	
	timer = 0
	onEvent("Loop", function(elapsed, remaining)
		local lim = 120
		if timer < lim * 1000 then
			ui.setMapName(("<O>Module will <R>shut down</R> in <D>%d s<"):format(lim - (timer/1000)))
		else
			system.exit()
		end
		timer = timer + 500
	end)

	tfm.exec.newGame('<C><P /><Z><S><S P=",,,,,,," L="75" H="10" T="14" Y="-150" X="400" /><S L="75" P=",,,,,,," T="14" Y="-185" X="415" H="10" /><S P=",,,,,,," L="75" X="385" T="14" Y="-185" H="10" /><S P=",,,,,,," L="200" H="150" T="14" Y="-175" N="" X="400" /></S><D><DS X="400" Y="-165" /></D><O /></Z></C>')
	tfm.exec.setWorldGravity(0, 0)
	for playerName, playerObject in next, tfm.get.room.playerList do
		tfm.exec.respawnPlayer(playerName)
		tfm.exec.freezePlayer(playerName, true, false)
	end
	
	local _ui_removeTextArea = ui.removeTextArea
	for i=0, 3000 do
		_ui_removeTextArea(i)
	end
	
	errorHandler = function() end
end

local actionsCount = 0
local actionsHandle = {}

if not os.time or type(os.time()) ~= "number" then
	error("os.time is messed up")
end

-- @prototypes