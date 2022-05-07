--[[
	This will search first over builder.lua, and then over
	every file in a require function recursively, so you
	can create infinite folders and files and they will be
	merged as long as they're rooted in some way to the
	builder.lua. Every other file outside of the builder or
	it's derivates will be ignored, as well as files types
	that don't have the .lua end. The resultant file from
	the merge will be 'micecraft.lua', which should be able
	to be loaded into the game without any problem.
]]

local depth = 0

local wrap
wrap = function(root, filename)
	local __file = io.open("./" .. root .. "/" .. filename .. ".lua", 'r')
	local filestr
	if __file then
		depth = 0
		filestr = __file:read("*all")
		__file:close()
	else
		if depth < 5 then
			depth = depth + 1
			return wrap(root .. "/" .. filename, "main")
		else
			return "-- Error on loading of " .. root .. "/" .. filename .. ".lua", "failure"
		end
	end

	local req = function(file)
		if file:sub(1, 7) == "require" then
			file = file:sub(10, -3)
		end
		
		return wrap(root, file)
	end
	
	return filestr:gsub('require%(".-"%)', req), "success"
end

local generatePrototype = function(wrappedFile)
	local file = "\n\t\n\t" .. wrappedFile
	local proto = "\nlocal "
	local _ff
	local prototypes = {}
	
	for _prev, _function in file:gmatch("(.-)%s([_%w]+)%s-=%s-function%(.-%)") do
		if _prev:gsub("%s", ""):sub(-5, -1) ~= "local" then
			table.insert(prototypes, _function)
		end
	end

	for i=1, #prototypes do
		_ff = prototypes[i]
		proto = proto .. (i==1 and "\t" or"\t\t") .. _ff .. (i ~= #prototypes and ",\n" or "\n\n\n")
	end

	return proto
end

local _failure = function(message)
	print("Error detected on checking over 'micecraft.lua': " .. message)
end

do
	local prototypesBuild = ""
	local __builder, success = io.open("./builder.lua", 'r')
	local builder
	if __builder then
		builder = __builder:read("*all")
		__builder:close()
	else
		error(success)
	end

	local build = "-- Micecraft --\n-- Script created by Indexinel#5948"
	local _fwrap, status
	for dir in builder:gmatch('require%("(%w+)"%)') do
		_fwrap, status = wrap(dir, "main")
		print(string.format(" [%s] %s", status, dir))
		build = build .. ("\n\n" .. "-- " .. string.rep("=", 10) .. '\t' .. string.upper(dir) .. '\t' .. string.rep("=", 10)) .. " --\n\n" .. _fwrap
		
		if dir ~= "resources" and dir ~= "main" and dir ~= "events" then 	prototypesBuild = prototypesBuild .. generatePrototype(_fwrap)
		end
	end
	
	build = build:gsub("-- @prototypes", prototypesBuild)
	local ltime = os.date("%d/%m/%Y %H:%M:%S")
	build = build:gsub("--@lastest", ltime) .. ("\n\n-- " .. ltime .. " --")
	local newBuild = io.open("./micecraft.lua", 'w')
	newBuild:write(build)
	newBuild:close()
	
	local exec, loadres = load('require("tfmenv")\n' .. build)-- .. "\n eventNewGame(); eventLoop()")
	if exec then
		local ok, result = pcall(exec)
		if ok then
			print("Module 'micecraft.lua' builded successfully. No errors.\n" .. build:len() .. " characters long\n")
			return
		else
			_failure(result)
		end
	else
		_failure(loadres)
	end
end


if a then
local eventFastLoopTimers = {}

local tickrate = 60
local pcheck = math.ceil(1000/tickrate)


local eventFastLoop = function(_, ms)
	tfm.exec.chatMessage("Every " .. pcheck .. " ms")
end

do
	local limit = pcheck > 1000 and pcheck+10 or 1000
	local _os_time = os.time
	local init = _os_time()
	local base = _os_time()
	local tt
	for i=1, 20000000 do
		tt = _os_time()
		if tt - init > limit then break end
		if tt - base > pcheck then
			table.insert(eventFastLoopTimers, system.newTimer(
				eventFastLoop, 1000, true, pcheck
			))
			base = tt
		end
	end

end
end