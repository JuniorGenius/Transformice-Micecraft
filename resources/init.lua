local string = string
local table = table

local system = system
local tfm = tfm
local ui = ui

local chunkSize = 12
local maxBounds = {height=256, width=1020}
local globalGrounds = 0

local timer = 0
local awaitTime = 3000

local xmlLoad = '<C><P Ca="" H="8392" L="32640" /><Z><S></S><D><DS X="%d" Y="%d" /></D><O /></Z></C>'

local room = {
	totalPlayers = 0,
	isTribe = (string.sub(tfm.get.room.name, 1, 2) == "*\003"),
	runtimeMax = 0,
	player = {}
}

local modulo = {
	creator = "Indexinel#5948",
	name = "Micecraft",
	loading = nil,
	sprite = "15150c10e92.png",
	runtimeLapse = 0,
	runtimeMax = 0,
	runtimeLimit = 0
}

modulo.runtimeMax = (room.isTribe and 40 or 60)
modulo.runtimeLimit = modulo.runtimeMax - 8

local map = {
	size = {
		height = maxBounds.height,
		width = maxBounds.width
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

do
	ui.addTextArea(999 , "<font size='64'><p align='center'>Initializing...</p></font>", nil, 100, 150, 600, 200, 0x000000, 0x000000, 1.0, true)
	modulo.loading = tfm.exec.addImage(modulo.sprite, "~999", 0, 0, nil, 1.0, 1.0, 0, 1.0, 0, 0)
end
