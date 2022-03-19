--[[
	Every module will be loaded in order, you can add more
	modules in case you need them, but the resources and
	prototypes modules must be placed first, and events &
	main must be the last ones. When you want to create a
	new module, you create a new folder, and into there
	you create a main.lua, where you can do 'require "any"'
	for every function or group you create. The merger.lua
	will iterate over every file inside a require and if it
	finds a require inside a file it will replace that with
	whatever file is inside that.
]]

require("resources")

require("utilities")

require("block")

require("chunk")

require("player")

require("item")

require("inventory")

require("worldHandle")

require("events")

require("main")