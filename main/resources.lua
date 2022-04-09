
local defTrunkDestroy = function(self, Player, norep)
	if not self.ghost then return end
	
	local upward = getPosBlock(self.dx + 16, self.dy - 216)
	local leavetype = self.type + 1
	
	if upward.type == leavetype then
		local dx, dy, yy = self.dx + 16, self.dy - 184
		local _getPosBlock, block = getPosBlock
		local h = 1
		
		for y=-4, -1 do
			yy = dy + (y*32)
			if y >= -2 then h = 2 end
			for x=-h, h do
				block = _getPosBlock(dx + (x*32), yy)
				
				if block.type == leavetype then
					block.timestamp = self.timestamp
					appendEvent(
						math.random(15,75)*1000,
						function(self, lt, pl)
							if self.timestamp == lt then
								blockDestroy(self, true, pl)
								blockDestroy(self, true, pl)
							end
						end,
						block, (self.timestamp), Player
					)
				end
			end
		end
	end
end

stackPresets = {
	["playerBag"] = {
		size = 32,
		lines = 4,
		collumns = 9,
		
		sprite = "17fcd0f1064.png",
		
		xSeparation = 2,
		ySperation = 4,
		
		xStart = 245,
		yStart = 209,
		
		xOffset = 0,
		yOffset = 2
	},
	
	["playerCraft"] = {
		size = 32,
		lines = 2,
		collumns = 2,
		
		sprite = "17fcd1000b4.png",
		
		xSeparation = 2,
		ySeparation = 2,
		
		xStart = 415,
		yStart = 88,
		
		xOffset = 0,
		yOffset = 0,
		
		output = 5,
		
		callback = function(self, playerObject)
			local item, itemList = stackFetchCraft(playerObject.inventory.craft, 4)
			local _i = playerObject.inventory.craft
			if item and itemList then
				return itemCreate(_i.slot[#_i.slot], item[1], item[2], true), itemList
			end
		end,
		
		slot = {
			[5] = {
				dx = 524,
				dy = 104,
				--callback = dummyFunc,
				insert = false
			}
		}
	},
	
	["Crafting Table"] = {
		size = 32,
		lines = 3,
		collumns = 3,
		
		sprite = "17fcd0f8b01.png",
		
		xSeparation = 2,
		ySeparation = 2,
		
		xStart = 302,
		yStart = 84,
		
		xOffset = 0,
		yOffset = 0,
		
		callback = function(self, playerObject, blockObject)
			local _i = blockObject.handle[playerObject.name] or blockObject.handle
			local item, itemList = stackFetchCraft(_i, 9)

			if item and itemList then
				return itemCreate(_i.slot[#_i.slot], item[1], item[2], true), itemList
			end
		end,
		
		output = 10,
		slot = {
			[10] = {
				dx = 458,
				dy = 113,
				--callback = dummyFunc,
				size = 48,
				insert = false
			}
		}
	},
	
	["playerArmor"] = {
		size = 32,
		lines = 4,
		collumns = 1,
		
		sprite = "17fcd0dfffa.png",
		
		ySeparation = 2,
		
		xStart = 250,
		yStart = 60,
		
		xOffset = 1,
	
		callback = dummyFunc,
		
		slot = {
			[5] = {
				dx = 374,
				dy = 163
			}
		}
	},
	["playerInvBar"] = {
		size = 32,
		lines = 1,
		collumns = 9,
		
		sprite = "17e464e9c5d.png",
		
		xSeparation = 2,
		
		xStart = 245,
		yStart = 352,
		
		yOffset = 3,
		
		callback = dummyFunc
	}
}

objectMetadata = {
--[[
[] = {
		name = "",
		drop = ,
		durability = ,
		glow = ,
		translucent = ,
		sprite = "",
		particles = {}
	},
]]
	-- ==========		DIRT		========== --
	[1] = {
		name = "Dirt",
		drop = 1,
		durability = 14,
		glow = 0,
		translucent = false,
		sprite = "17dd4af277b.png",
		interact = false,
		particles = {21, 24, 44},
		onAwait = function(self, Player, tl)
			if self.timestamp == tl and self.type == 1 then
				blockCreate(self, 2, self.ghost, true, Player)
			end
		end,
		onUpdate = function(self, Player)
			local block = getPosBlock(self.dx + 16, self.dy - 216)
			if block.type == 0 then
				self.event = appendEvent(
					math.random(7000, 10000), 
					self.onAwait, 
					self, Player, (self.timestamp)
				)
			end
		end,
		onDestroy = function(self, Player)
			if self.event then
				removeEvent(self.event)
				self.event = nil
			end
		end,
		onPlacement = function(self, Player)
			self:onUpdate(Player)
		end
	},
	[2] = {
		name = "Grass",
		drop = 1,
		durability = 14,
		glow = 0,
		translucent = false,
		sprite = "17dd4b0a359.png",
		interact = false,
		particles = {21, 22, 44},
		onAwait = function(self, Player, tl)
			if self.timestamp == tl and self.type == 2 then
				blockCreate(self, 1, self.ghost, true, Player)
			end
		end,
		onUpdate = function(self, Player)
			local block = getPosBlock(self.dx + 16, self.dy - 216)
			if block.type ~= 0 then
				self.event = appendEvent(
					math.random(3000, 5000),
					self.onAwait,
					self, Player, (self.timestamp)
				)
			end
		end,
		onDestroy = function(self, Player)
			if self.event then
				removeEvent(self.event)
				self.event = nil
			end
		end
	},
	[3] = {
		name = "Snowed Dirt",
		drop = 1,
		durability = 14,
		glow = 0,
		translucent = false,
		sprite = "17dd4aedb5d.png",
		interact = false,
		particles = {4, 21, 44, 45}
	},
	[4] = {
		name = "Snow",
		drop = 4,
		durability = 8,
		glow = 0,
		translucent = false,
		sprite = "17dd4b5fb5d.png",
		interact = false,
		particles = {4, 45}
	},
	[5] = {
		name = "Dirtcelium",
		drop = 1,
		durability = 16,
		glow = 0,
		translucent = false,
		sprite = "17dd4ae8f5b.png",
		interact = false,
		particles = {21, 21, 32, 43}
	},
	[6] = {
		name = "Mycelium",
		drop = 6,
		durability = 16,
		glow = 0,
		translucent = false,
		sprite = "17dd4b1875c.png",
		interact = false,
		particles = {43}
	},
	-- ==========		STONE		========== --
	[10] = {
		name = "Stone",
		drop = 19,
		durability = 34,
		glow = 0,
		translucent = false,
		sprite = "17dd4b6935c.png",
		interact = false,
		particles = {3, 4}
	},
	[11] = {
		name = "Coal Ore",
		drop = 11,
		durability = 42,
		glow = 0,
		translucent = false,
		sprite = "17dd4b26b5d.png",
		interact = false,
		particles = {3, 4}
	},
	[12] = {
		name = "Iron Ore",
		drop = 12,
		durability = 46,
		glow = 0.2,
		translucent = false,
		sprite = "17dd4b39b5c.png",
		interact = false,
		particles = {3, 2, 1}
	},
	[13] = {
		name = "Gold Ore",
		drop = 13,
		durability = 46,
		glow = 0.4,
		translucent = false,
		sprite = "17dd4b34f5a.png",
		interact = false,
		particles = {2, 3, 11, 24}
	},
	[14] = {
		name = "Diamond Ore",
		drop = 14,
		durability = 52,
		glow = 0.8,
		translucent = false,
		sprite = "17dd4b2b75d.png",
		interact = false,
		particles = {3, 1, 9, 23} 
	},
	[15] = {
		name = "Emerald Ore",
		drop = 15,
		durability = 52,
		glow = 0.7,
		translucent = false,
		sprite = "17dd4b3035f.png",
		interact = false,
		particles = {3, 11, 22}
	},
	[16] = {
		name = "Lazuli Ore",
		drop = 16,
		durability = 34,
		glow = 0.3,
		translucent = false,
		sprite = "17e46514c5d.png",
		interact = false,
		particles = {}
	},
	[19] = {
		name = "Cobblestone",
		drop = 19,
		durability = 26,
		glow = 0,
		translucent = false,
		sprite = "17dd4adf75b.png",
		interact = false,
		particles = {3}
	},
	-- ==========		SAND		========== --
	[20] = {
		name = "Sand",
		drop = 20,
		durability = 10,
		glow = 0,
		translucent = false,
		sprite = "17dd4b5635b.png",
		interact = false,
		particles = {24}
	},
	[21] = {
		name = "Sandstone",
		drop = 21,
		durability = 26,
		glow = 0,
		translucent = false,
		sprite = "17dd4b5af5c.png",
		interact = false,
		particles = {3, 24, 24}
	},
	[25] = {
		name = "Cactus",
		drop = 25,
		durability = 10,
		glow = 0,
		translucent = false,
		sprite = "17e4651985c.png",
		interact = false,
		particles = {}
	},
	-- ==========		UTILITIES		========== --
	[50] = {
		name = "Crafting Table",
		drop = 50,
		durability = 24,
		glow = 0,
		translucent = false,
		sprite = "17dd4ae435c.png",
		interact = true,
		particles = {1},
		handle = {
			stackNew, 10, "Crafting Table",
			stackPresets["Crafting Table"],
			0, "Crafting Table"
		},
		onInteract = function(self, playerObject)
			playerObject.inventory.bridge = blockGetInventory(self)
			
            playerHideInventory(playerObject)
            playerDisplayInventory(
                playerObject,
                {{"bag", 0, 0, true}, 
                {"invbar", 0, -36, false}, 
                {"bridge", 0, 0, true}}
            )
		end
	},
	[51] = {
		name = "Oven",
		drop = 51,
		durability = 40,
		glow = 0,
		translucent = false,
		sprite = "17dd4b4335d.png",
		interact = true,
		particles = {3, 1}
	},
	[52] = {
		name = "Oven",
		drop = 51,
		durability = 40,
		glow = 2,
		translucent = false,
		sprite = "17dd4b3e75b.png",
		interact = true,
		particles = {3, 1}
	},
	
	[70] = {
		name = "Wood",
		drop = 70,
		durability = 24,
		glow = 0,
		translucent = false,
		sprite = "17e46510078.png",
		interact = false,
		particles = {}
	},
	[73] = {
		name = "Jungle Trunk",
		drop = 73,
		durability = 24,
		glow = 0,
		translucent = false,
		sprite = "17e4651e45d.png",
		interact = false,
		particles = {},
		onDestroy = defTrunkDestroy
	},
	[74] = {
		name = "Jungle Leaves",
		drop = 74,
		durability = 4,
		glow = 0,
		translucent = false,
		sprite = "17e4652c85c.png",
		interact = false,
		particles = {}
	},
	[75] = {
		name = "Fir Trunk",
		drop = 75,
		durability = 24,
		glow = 0,
		translucent = false,
		sprite = "17e46527c5e.png",
		interact = false,
		particles = {},
		onDestroy = defTrunkDestroy
	},
	[76] = {
		name = "Fir Leaves",
		drop = 76,
		durability = 4,
		glow = 0,
		translucent = false,
		sprite = "17e46501bd8.png",
		interact = false,
		particles = {}
	},
	[80] = {
		name = "Pumpkin",
		drop = 80,
		durability = 24,
		glow = 0,
		translucent = false,
		sprite = "17dd4b5175b.png",
		interact = false,
		particles = {}
	},
	[81] = {
		name = "Pumpkin Mask",
		drop = 81,
		durability = 20,
		glow = 0,
		translucent = false ,
		sprite = "17dd4b4cb5c.png",
		interact = true,
		particles = {}
	},
	[82] = {
		name = "Pumpkin Torch",
		drop = 82,
		durability = 24,
		glow = 3.5,
		translucent = 0,
		sprite = " 17dd4b47f5a.png",
		interact = true,
		particles = {}
	},
	[100] = {
		name = "Ice",
		drop = 0,
		durability = 6,
		glow = 0,
		translucent = true,
		sprite = "x0xKxfi",
		interact = false,
		particles = {}
	},
	[108] = {
		name = "Crystal",
		drop = 0,
		durability = 6,
		translucent = true,
		sprite = "17e4652305d.png",
		interact = false,
		particles = {}
	},
	-- ==========		NETHER		========== --
	[130] = {
		name = "Netherrack",
		drop = 130,
		durability = 26,
		glow = 0,
		translucent = false,
		sprite = "17dd4b1d35c.png",
		interact = false,
		particles = {43, 44}
	},
	[139] = {
		name = "Soulsand",
		drop = 29,
		durability = 20,
		glow = 0,
		translucent = false,
		sprite = "17dd4b6475d.png",
		interact = false,
		particles = {3, 43}
	},
	-- ==========		END		========== --
	[170] = {
		name = "Endstone",
		drop = 170,
		durability = 26,
		glow = 0,
		translucent = false,
		sprite = "17dd4b00b5b.png",
		interact = false,
		particles = {24, 32}
	},
	[178] = {
		name = "End Portal",
		drop = 178,
		durability = 52,
		glow = 0,
		translucent = true,
		sprite = "17dd4afbf5b.png",
		interact = true,
		particles = {3, 22, 23, 34}
	},
	[179] = {
		name = "End Portal (activated)",
		drop = 178,
		durability = 52,
		glow = 0.7,
		translucent = true,
		sprite = "17dd4af735a.png",
		interact = true,
		particles = {3, 22, 23, 34}
	},

    [192] = {
        name = "TNT",
        drop = 192,
        durability = 18,
        glow = 0,
        translucent = false,
        sprite = "17ff03debf2.png",
        interact = true,
        particles = {},
        onInteract = function(self, ...)
            appendEvent(3000, self.onAwait, self, ...)
        end,
        onAwait = function(self, playerObject)
            worldExplosion(self.dx+16, self.dy+16, 3, 1.25, playerObject)
            blockDestroy(self, true, playerObject)
        end
    },
	-- ==========		MISC		========== --
	[256] = {
		name = "Bedrock",
		drop = 256,
		durability = -1,
		glow = 0,
		translucent = false,
		sprite = "17dd4adaaf0.png",
		interact = false,
		particles = {3, 3, 3, 4, 4, 36}
	}
	
	
	-- ===========================		 NON BLOCKS 		=========================== --
	
	
}