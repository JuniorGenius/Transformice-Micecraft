--[[
	Every module will be loaded in order, you can add more
	modules in case you need them, but the resources and
	prototypes modules must be placed first, and events &
	main must be the last ones. When you want to create a
	new module, you create a new folder, and into there
	you create a main.lua, where you can do 'require "any"'
	for every function or group you create. The merger.lua
	will iterate over every file inside a require to replace
	the require with the file string, and if it find another
	require then it will repeat the proccess, as long as you
	put a valid file/path.
]]

require("resources")

require("utilities")

require("uiHandle")

require("translations")

require("block")

require("chunk")

require("item")

require("player")

require("slot")

require("inventory")

require("worldHandle")

require("events")

require("main")