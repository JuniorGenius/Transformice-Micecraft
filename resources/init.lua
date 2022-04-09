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
	setMode = string.match(tfm.get.room.name, "micecraft%A+([_%a]+)"),
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
				errorHandler(result, eventName, i)
				return
			end
		end
	end
	
	_G["event" .. eventName] = function(...)
		if event and event[eventName] then return event[eventName][0](...) end
	end
end

errorHandler = function(err, eventName, instance)
	tfm.exec.addImage("17f94a1608c.png", "~42", 0, 0, nil, 1.0, 1.0, 0, 1.0, 0, 0)
	tfm.exec.addImage("17f949fcbb4.png", "~43", 70, 120, nil, 1.0, 1.0, 0, 1.0, 0, 0)
	ui.addTextArea(42069,
		string.format(
			"<p align='center'><font size='18'><R><B><font face='Wingdings'>M</font> Fatal Error</B></R></font>\n\n<CEP>%s</CEP>\n\n<CS>%s</CS>\n\n%s\n\n\n<CH>Send this to Indexinel#5948</CH>",
			err, debug.traceback(),
			(eventName and instance) and ("<D>Event: <V>event" .. eventName .. "</V> #" .. instance .. "</D>") or ""
		),
		nil,
		100, 50,
		600, 300,
		0x010101, 0x010101,
		0.8, true
	)

	for name, evt in next, event do
		if name == "Loop" then
			event["PlayerDied"] = nil
			for _, act in next, evt do
				act = nil
			end
			timer = 0
			evt[1] = function(elapsed, remaining)
				timer = timer + 500
				local lim = 120
				if timer < lim*1000 then
					ui.setMapName(
						("<O>Module will <R>shut down</R> in <D>%d s<"):format(
							math.ceil(lim-(timer/1000))
						)
						
					)
				else
					system.exit()
				end
			end
		else
			evt = nil
		end
	end
	
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
	
	eventHandler = function()
		return
	end
end

local actionsCount = 0
local actionsHandle = {}

-- @prototypes