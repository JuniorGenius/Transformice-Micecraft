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
      return "-- Error on loading of " .. root .. "/" .. filename .. ".lua"
    end
  end

	local req = function(file)
    if file:sub(1, 7) == "require" then
      file = file:sub(10, -3)
    end
    return wrap(root, file)
  end
	
	return filestr:gsub('require%(".-"%)', req)
end

do
	local __builder, success = io.open("./builder.lua", 'r')
  local builder
  if __builder then
    builder = __builder:read("*all")
    __builder:close()
  else
    error(success)
  end

	local build = ""
	for dir in builder:gmatch('require%("(%w+)"%)') do
    print(dir)
		build = build .. (string.rep('\n', 3) .. "-- " .. string.rep("=", 10) .. '\t' .. string.upper(dir) .. '\t' .. string.rep("=", 10)) .. " --\n\n" .. wrap(dir, "main")
	end
	
	local newBuild = io.open("./micecraft.lua", 'w')
	newBuild:write(build .. ("\n\n--" .. os.date("%d/%m/%Y %H:%M:%S")))
	newBuild:close()
	
	print("Success.")
end