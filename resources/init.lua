local string = string
local table = table

local system = system
local tfm = tfm
local ui = ui

local globalGrounds = 0

local timer = 0
local awaitTime = 3000

local xmlLoad = '<C><P Ca="" H="8392" L="32640" /><Z><S></S><D><DS X="%d" Y="%d" /></D><O /></Z></C>'

local dummyFunc = function() return end

local room = {
	totalPlayers = 0,
	isTribe = (string.sub(tfm.get.room.name, 1, 2) == "*\003"),
	runtimeMax = 0,
	player = {}
}

local modulo = {
	creator = "Indexinel#5948",
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
  timeout = false
}

modulo.runtimeMax = (room.isTribe and 40 or 60)
modulo.runtimeLimit = modulo.runtimeMax - 8

local map = {
	size = {
		height = 256,
		width = 1020
	},
	chunk = {},
	
	type = 0,
	
	background = nil,
	
	seed = 0,
	
	loadingTotalTime = 0,
	loadingAverageTime = 0,
	totalLoads = 0,
	
	spawnPoint = {},
	heightMaps = {},
	handle = {},
	timestamp = 0,
	
	structures = {}
	--[[sun = {
		x = 16320,
		y = 200,---5000,
		glow = 1024--2000
	}]]
}
local event = {}
local onEvent, errorHandler
onEvent = function(eventName, callback)
	if not event[eventName] then
		event[eventName] = {}
	end
	table.insert(event[eventName], callback)
	
	event[eventName][0] = function(...)
		for i=1, #event[eventName] do
			local ok, result = pcall(event[eventName][i], ...)
			
			if not ok then
				errorHandler(result)
				return
			end
		end
	end
	
	_G["event" .. eventName] = function(...)
		if event and event[eventName] then return event[eventName][0](...) end
	end
end

errorHandler = function(err)
	tfm.exec.addImage("17f94a1608c.png", ":42", 0, 0, nil, 1.0, 1.0, 0, 1.0, 0, 0)
	tfm.exec.addImage("17f949fcbb4.png", "~43", 70, 120, nil, 1.0, 1.0, 0, 1.0, 0, 0)
	ui.addTextArea(42069,
		string.format(
			"<p align='center'><font size='18'><R><B><font face='Wingdings'>M</font> Fatal Error</B></R></font>\n\n<CEP>%s</CEP>\n\n<CS>%s</CS>\n\n\n<CH>Send this to Indexinel#5948</CH>",
			err, debug.traceback()
		),
		nil,
		200, 100,
		400, 200,
		0x010101, 0x010101,
		0.8, true
	)

	event = nil
	
	tfm.exec.newGame(7886400)
	tfm.exec.setWorldGravity(0, 0)
	for playerName, playerObject in next, tfm.get.room.playerList do
		tfm.exec.respawnPlayer(playerName)
		tfm.exec.freezePlayer(playerName, true, false)
	end
	
	local _ui_removeTextArea = ui.removeTextArea
	for i=0, 3000 do
		_ui_removeTextArea(i)
	end
	
	eventHandler = function()
		return
	end
end

local game = function()