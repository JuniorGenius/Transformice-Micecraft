
-- If the data references a function, then put it in ./main/resources
-- If not, put it here. Just make sure to declare the local variable
-- here so its scope is still reachable by the functions that use them.

local structureData = {
	[1] = { -- {type, ghost, xoff, yoff}
		0,{72,true,-1,-7},{72,false,0,-7},{72,true,1,-7},0,
		0,{72,false,-1,-6},{72,false,0,-6},{72,false,1,-6},0,
		{72,false,-2,-5},{72,false,-1,-5},{72,false,0,-5},{72,false,1,-5},{72,false,2,-5},
		{72,false,-2,-4},{72,false,-1,-4},{72,false,0,-4},{72,false,1,-4},{72,false,2,-4},
		0,0,{71,false,0,-3},0,0,
		0,0,{71,false,0,-2},0,0,
		0,0,{71,false,0,-1},0,0
	}
}

local craftsData = {
	--[[
		Structure (for optimization):
		array[1] = Crafting composition
			- sub[n] = block at the n position in the crafting table
		array[2] = Crafting result
			- sub[1] = item recompense
			- sub[2] = amount of the item
	]]
	{{{1,1}, {1,1}}, {6, 64}},
	{{{19,19,19}, {19,0,19}, {19,19,19}}, {51, 1}},
	{{{73}}, {70, 4}},
	{{{75}}, {70, 4}},
	{{{70,70}, {70,70}}, {50, 1}},
	{{{70},{70}}, {513, 4}},
	-- Pickaxe
	{{{70,70,70},{0,513,0},{0,513,0}}, {530, 1}},
	{{{19,19,19},{0,513,0},{0,513,0}}, {531, 1}},
	{{{521,521,521},{0,513,0},{0,513,0}}, {532, 1}},
	{{{522,522,522},{0,513,0},{0,513,0}}, {534, 1}},
	-- Sword
	{{{70},{70},{513}}, {540,1}},
	{{{19},{19},{513}}, {541,1}},
	{{{521},{521},{513}}, {542,1}},
	{{{522},{522},{513}}, {544,1}},
	-- Axe {{}, {,}},
	{{{70,70},{70,513},{0,513}}, {550,1}},
	{{{19,19},{19,513},{0,513}}, {551,1}},
	{{{521,521},{521,513},{0,513}}, {552,1}},
	{{{522,522},{522,513},{0,513}}, {554,1}},
	-- Shovel
	{{{70},{513},{513}}, {560,1}},
	{{{19},{513},{513}}, {561,1}},
	{{{521},{513},{513}}, {562,1}},
	{{{522},{513},{513}}, {564,1}}
}

local stackPresets
local objectMetadata

--[[local furnaceData = {
	{source, {returns, quantity}},
}]]

local damageSprites = {"17dd4b6df60.png", "17dd4b72b5d.png", "17dd4b7775d.png", "17dd4b7c35f.png", "17dd4b80f5e.png", "17dd4b85b5f.png", "17dd4b8a75e.png", "17dd4b8f35f.png", "17dd4b93f5e.png", "17dd4b98b5d.png"}

local mossSprites = {"17dd4b9d75e.png", "17dd4bb075d.png", "17dd4ba235f.png", "17dd4babb5c.png", "17dd4ba6f77.png"}

local shadowSprite = "17e2d5113f3.png"

local cmyk = {{"17e13158459.png", 0}, {"17e13161c88.png", 0}, {"17e1316685d.png", 0}, {"17e1315d05f.png", 0}}