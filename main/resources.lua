
local defTrunkDestroy = function(self, Player, norep)
	if not self.ghost then return end
	
	local upward = getPosBlock(self.dx + 16, self.dy - 216)
	local leavetype = self.type + 1
	
	if upward.type == leavetype then
		local yy, block
		local dx, dy = self.dx + 16, self.dy - 184
		local _getPosBlock = getPosBlock
		local h = 1
		
		for y=-4, -1 do
			yy = dy + (y*32)
			if y >= -2 then h = 2 end
			for x=-h, h do
				block = _getPosBlock(dx + (x*32), yy)
				
				if block.type == leavetype then
					block.timestamp = self.timestamp
					appendEvent(
						math.random(15,75)*1000, false,
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
			local stackObject = playerObject.inventory.craft
			
			if stackObject then
				local result = stackFetchCraft(stackObject)
				if result then
					local retval = slotFill(
						stackObject.slot[#stackObject.slot], 
						result[1], result[2],
						true
					)
					
					slotRefresh(stackObject.slot[#stackObject.slot], playerObject.name)
					
					return retval
				end
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
			local stackObject = playerObject.inventory[self.stack]
			if stackObject then
				local result = stackFetchCraft(stackObject)

				if result then
					local retval = slotFill(
						stackObject.slot[#stackObject.slot], 
						result[1], result[2],
						true
					)
					
					slotRefresh(stackObject.slot[#stackObject.slot], playerObject.name)
					
					return retval
				end
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

objectMetadata = {}
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
do
	-- ==========		DIRT		========== --
	objectMetadata[1] = {
		name = "Dirt",
		drop = 1,
		durability = 14,
		glow = 0,
		translucent = false,
		hardness = 0,
		placeable = true,
		sprite = "17dd4af277b.png",
		interact = false,
		particles = {21, 24, 44},
		ftype = 2,
		onAwait = function(self, Player, tl)
			if self.timestamp == tl and self.type == 1 then
				blockCreate(self, 2, self.ghost, true, Player)
			end
		end,
		onUpdate = function(self, Player)
			local block = getPosBlock(self.dx + 16, self.dy - 216)
			if block.type == 0 then
				self.event = appendEvent(
					math.random(7000, 10000), false,
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
	}
	
	objectMetadata[2] = {
		name = "Grass",
		drop = 1,
		durability = 14,
		glow = 0,
		translucent = false,
		placeable = true,
		hardness = 0,
		sprite = "17dd4b0a359.png",
		interact = false,
		ftype = 2,
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
					math.random(3000, 5000), false,
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
	}
	
	objectMetadata[3] = {
		name = "Snowed Dirt",
		drop = 1,
		durability = 14,
		glow = 0,
		translucent = false,
		ftype = 2,
		placeable = true,
		hardness = 0,
		sprite = "17dd4aedb5d.png",
		interact = false,
		particles = {4, 21, 44, 45}
	}
	
	objectMetadata[4] = {
		name = "Snow",
		drop = 4,
		durability = 8,
		glow = 0,
		translucent = false,
		ftype = 2,
		placeable = true,
		hardness = 0,
		sprite = "17dd4b5fb5d.png",
		interact = false,
		particles = {4, 45}
	}
	
	objectMetadata[5] = {
		name = "Dirtcelium",
		drop = 1,
		durability = 16,
		glow = 0,
		translucent = false,
		placeable = true,
		ftype = 2,
		hardness = 0,
		sprite = "17dd4ae8f5b.png",
		interact = false,
		particles = {21, 21, 32, 43}
	}
	
	objectMetadata[6] = {
		name = "Mycelium",
		drop = 6,
		durability = 16,
		glow = 0,
		translucent = false,
		placeable = true,
		ftype = 2,
		hardness = 0,
		sprite = "17dd4b1875c.png",
		interact = false,
		particles = {43}
	}
	
	-- ==========		STONE		========== --
	objectMetadata[10] = {
		name = "Stone",
		drop = 19,
		durability = 34,
		glow = 0,
		translucent = false,
		placeable = true,
		ftype = 5,
		hardness = 1,
		sprite = "17dd4b6935c.png",
		interact = false,
		particles = {3, 4}
	}
	
	objectMetadata[11] = {
		name = "Coal Ore",
		drop = 520,
		durability = 42,
		glow = 0,
		placeable = true,
		translucent = false,
		ftype = 5,
		hardness = 1,
		sprite = "17dd4b26b5d.png",
		interact = false,
		particles = {3, 4}
	}
	
	objectMetadata[12] = {
		name = "Iron Ore",
		drop = 521,
		durability = 46,
		glow = 0.2,
		translucent = false,
		placeable = true,
		hardness = 2,
		ftype = 5,
		sprite = "17dd4b39b5c.png",
		interact = false,
		particles = {3, 2, 1}
	}
	
	objectMetadata[13] = {
		name = "Gold Ore",
		drop = 13,
		durability = 46,
		glow = 0.4,
		translucent = false,
		hardness = 2,
		ftype = 5,
		sprite = "17dd4b34f5a.png",
		interact = false,
		particles = {2, 3, 11, 24}
	}
	
	objectMetadata[14] = {
		name = "Diamond Ore",
		drop = 522,
		durability = 52,
		glow = 0.8,
		hardness = 3,
		placeable = true,
		ftype = 5,
		translucent = false,
		sprite = "17dd4b2b75d.png",
		interact = false,
		particles = {3, 1, 9, 23} 
	}
	
	objectMetadata[15] = {
		name = "Emerald Ore",
		drop = 15,
		durability = 52,
		glow = 0.7,
		translucent = false,
		hardness = 3,
		ftype = 5,
		placeable = true,
		sprite = "17dd4b3035f.png",
		interact = false,
		particles = {3, 11, 22}
	}
	
	objectMetadata[16] = {
		name = "Lazuli Ore",
		drop = 16,
		durability = 34,
		glow = 0.3,
		ftype = 5,
		hardness = 2,
		translucent = false,
		placeable = true,
		sprite = "17e46514c5d.png",
		interact = false,
		particles = {}
	}
	
	objectMetadata[19] = {
		name = "Cobblestone",
		drop = 19,
		durability = 26,
		placeable = true,
		glow = 0,
		hardness = 1,
		ftype = 5,
		translucent = false,
		sprite = "17dd4adf75b.png",
		interact = false,
		particles = {3}
	}
	
	-- ==========		SAND		========== --
	objectMetadata[20] = {
		name = "Sand",
		drop = 20,
		durability = 10,
		glow = 0,
		ftype = 1,
		placeable = true,
		translucent = false,
		sprite = "17dd4b5635b.png",
		interact = false,
		particles = {24}
	}
	
	objectMetadata[21] = {
		name = "Sandstone",
		drop = 21,
		durability = 26,
		glow = 0,
		ftype = 5,
		translucent = false,
		sprite = "17dd4b5af5c.png",
		interact = false,
		placeable = true,
		particles = {3, 24, 24}
	}
	
	objectMetadata[25] = {
		name = "Cactus",
		drop = 25,
		durability = 10,
		glow = 0,
		ftype = 6,
		translucent = false,
		placeable = true,
		sprite = "17e4651985c.png",
		interact = false,
		particles = {}
	}
	
	-- ==========		UTILITIES		========== --
	objectMetadata[50] = {
		name = "Crafting Table",
		drop = 50,
		durability = 24,
		glow = 0,
		ftype = 4,
		translucent = false,
		placeable = true,
		sprite = "17dd4ae435c.png",
		interact = true,
		particles = {1},
		handle = {
			stackNew, 10, "Crafting Table",
			stackPresets["Crafting Table"],
			36
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
	}
	
	objectMetadata[51] = {
		name = "Oven",
		drop = 51,
		durability = 40,
		glow = 0,
		ftype = 5,
		placeable = true,
		hardness = 1,
		translucent = false,
		sprite = "17dd4b4335d.png",
		interact = true,
		particles = {3, 1}
	}
	
	objectMetadata[52] = {
		name = "Oven",
		drop = 51,
		durability = 40,
		glow = 2,
		ftype = 5,
		hardness = 1,
		translucent = false,
		placeable = true,
		sprite = "17dd4b3e75b.png",
		interact = true,
		particles = {3, 1}
	}
	
	objectMetadata[70] = {
		name = "Wood",
		drop = 70,
		durability = 24,
		glow = 0,
		placeable = true,
		ftype = 4,
		translucent = false,
		sprite = "17e46510078.png",
		interact = false,
		particles = {}
	}
	
	objectMetadata[73] = {
		name = "Jungle Trunk",
		drop = 73,
		durability = 24,
		glow = 0,
		placeable = true,
		ftype = 4,
		translucent = false,
		sprite = "17e4651e45d.png",
		interact = false,
		particles = {},
		onDestroy = defTrunkDestroy
	}
	
	objectMetadata[74] = {
		name = "Jungle Leaves",
		drop = 74,
		durability = 4,
		glow = 0,
		ftype = 3,
		placeable = true,
		translucent = false,
		sprite = "17e4652c85c.png",
		interact = false,
		particles = {}
	}
	
	objectMetadata[75] = {
		name = "Fir Trunk",
		drop = 75,
		durability = 24,
		glow = 0,
		ftype = 4,
		translucent = false,
		sprite = "17e46527c5e.png",
		placeable = true,
		interact = false,
		particles = {},
		onDestroy = defTrunkDestroy
	}
	
	objectMetadata[76] = {
		name = "Fir Leaves",
		drop = 76,
		durability = 4,
		glow = 0,
		ftype = 3,
		placeable = true,
		translucent = false,
		sprite = "17e46501bd8.png",
		interact = false,
		particles = {}
	}
	
	objectMetadata[80] = {
		name = "Pumpkin",
		drop = 80,
		durability = 24,
		glow = 0,
		ftype = 4,
		placeable = true,
		translucent = false,
		sprite = "17dd4b5175b.png",
		interact = false,
		particles = {}
	}
	
	objectMetadata[81] = {
		name = "Pumpkin Mask",
		drop = 81,
		durability = 20,
		glow = 0,
		ftype = 4,
		placeable = true,
		translucent = false ,
		sprite = "17dd4b4cb5c.png",
		interact = true,
		particles = {}
	}
	
	objectMetadata[82] = {
		name = "Pumpkin Torch",
		drop = 82,
		durability = 24,
		glow = 3.5,
		placeable = true,
		ftype = 4,
		translucent = 0,
		sprite = "17dd4b47f5a.png",
		interact = true,
		particles = {}
	}
	
	objectMetadata[100] = {
		name = "Ice",
		drop = 0,
		durability = 6,
		glow = 0,
		placeable = true,
		ftype = 7,
		translucent = true,
		--sprite = "x0xKxfi",
		interact = false,
		particles = {}
	}
	
	objectMetadata[108] = {
		name = "Crystal",
		drop = 0,
		ftype = 7,
		durability = 6,
		placeable = true,
		translucent = true,
		sprite = "17e4652305d.png",
		interact = false,
		particles = {}
	}
	-- ==========		NETHER		========== --
	objectMetadata[130] = {
		name = "Netherrack",
		drop = 130,
		durability = 26,
		glow = 0,
		ftype = 5,
		hardness = 1,
		translucent = false,
		placeable = true,
		sprite = "17dd4b1d35c.png",
		interact = false,
		particles = {43, 44}
	}
	
	objectMetadata[139] = {
		name = "Soulsand",
		drop = 139,
		durability = 20,
		glow = 0,
		ftype = 1,
		translucent = false,
		sprite = "17dd4b6475d.png",
		interact = false,
		placeable = true,
		particles = {3, 43}
	}
	-- ==========		END		========== --
	objectMetadata[170] = {
		name = "Endstone",
		drop = 170,
		durability = 26,
		glow = 0,
		ftype = 5,
		placeable = true,
		hardness = 1,
		translucent = false,
		sprite = "17dd4b00b5b.png",
		interact = false,
		particles = {24, 32}
	}
	
	objectMetadata[178] = {
		name = "End Portal",
		drop = 0,
		durability = 52,
		glow = 0,
		ftype = 5,
		translucent = true,
		placeable = true,
		sprite = "17dd4afbf5b.png",
		interact = true,
		particles = {3, 22, 23, 34}
	}
	
	objectMetadata[179] = {
		name = "End Portal (activated)",
		drop = 0,
		durability = 52,
		glow = 0.7,
		ftype = 5,
		translucent = true,
		sprite = "17dd4af735a.png",
		interact = true,
		placeable = true,
		particles = {3, 22, 23, 34}
	}

    objectMetadata[192] = {
        name = "TNT",
        drop = 192,
        durability = 18,
        glow = 0,
		ftype = 2,
        translucent = false,
		placeable = true,
        sprite = "17ff03debf2.png",
        interact = true,
        particles = {},
        onInteract = function(self, ...)
            appendEvent(3000, false, self.onAwait, self, ...)
        end,
        onAwait = function(self, playerObject)
            worldExplosion(self.dx+16, self.dy+16, 3, 1.25, playerObject)
            blockDestroy(self, true, playerObject)
        end
    }
	-- ==========		MISC		========== --
	objectMetadata[256] = {
		name = "Bedrock",
		drop = 256,
		durability = math.huge,
		glow = 0,
		ftype = 0,
		placeable = true,
		translucent = false,
		sprite = "17dd4adaaf0.png",
		interact = false,
		particles = {3, 3, 3, 4, 4, 36}
	}
	
	
	-- ===========================		 NON BLOCKS 		=========================== --
	
--[[
object = {
  name = "Name",
  sprite = "a801url.png",
  
  hardness = 0 - 5,
  ftype = { -- Efectivity against n type of block
    [0-7] = xR
		0: all
		1: sands
		2: dirts
		3: weak obj/leaf
		4: woods
		5: rocks/metal
		6: wool
		7: glass
  },

  durability = 0-8192, -- Every click = one use
  sharpness = 0-64, -- Against entities
  strenght = 0-128, -- Against blocks

  cooldown = 0 - 5000 ms,
  particles = {}
  
}]]


	objectMetadata[513] = {
		name = "Stick",
		
		durability = 0,
		
		hardness = 0,
		sharpness = 0,
		strenght = 0,
		
		cooldown = 0,
		
		sprite = "180c2bbb255.png",
		
		particles = {}
	}
	
	objectMetadata[520] = {
		name = "Coal",
		sprite = "180c4521f6a.png",
		burningPower = 8
	}
	
	objectMetadata[521] = {
		name = "Iron",
		sprite = "180c4524911.png"
	}
	
	objectMetadata[522] = {
		name = "Diamond",
		sprite = "180c4528cb2.png"
	}
	
	objectMetadata[530] = {
		name = "Wood Pickaxe",
		
		sprite = "180c2f4fb48.png",
		hardness = 1,
		ftype = {
			[1] = 0.25, -- Sand
			[2] = 0.33, -- Dirt
			[3] = 0.75, -- Leafs/weak obj
			[4] = 0.5, -- Wood
			[5] = 1.0, -- Rocks/Metal
			[6] = 0.75, -- Wool
			[7] = 1.25 -- Glass
		},
		
		durability = 680,
		sharpness = 2.5,
		strenght = 5,
		
		degradable = true,
		
		cooldown = 250
		
	}
	
	objectMetadata[531] = inherit(objectMetadata[530], {
		name = "Stone Pickaxe",
		sprite = "180c2f52e49.png",
		hardness = 2,
		durability = 1620,
		sharpness = 3.5,
		strenght = 8
	})

	objectMetadata[532] = inherit(objectMetadata[530], {
		name = "Iron Pickaxe",
		sprite = "180c2f55dea.png",
		hardness = 3,
		durability = 3240,
		sharpness = 5,
		strenght = 13
	})

	objectMetadata[533] = inherit(objectMetadata[532], {
		name = "Golden Pickaxe",
		sprite = "",
		durability = 2430,
		strenght = 19,
		cooldown = 150
	})

	objectMetadata[534] = inherit(objectMetadata[530], {
		name = "Diamond Pickaxe",
		sprite = "180c2f58791.png",
		hardness = 5,
		durability = 6480,
		sharpness = 6,
		strenght = 28
	})

	objectMetadata[540] = {
		name = "Wood Sword",
		
		sprite = "180c316cfba.png",
		hardness = 0,
		ftype = {
			[1] = 0.4,
			[2] = 0.5,
			[3] = 3.0,
			[4] = 1.0,
			[5] = 0.4,
			[6] = 2.5,
			[7] = 1.25
		},
		
		durability = 680,
		sharpness = 4,
		strenght = 2.5,
		
		degradable = true,
		
		cooldown = 400
	}
	
	objectMetadata[541] = inherit(objectMetadata[540], {
		name = "Stone Sword",
		sprite = "180c31713af.png",
		durability = 1540,
		sharpness = 5
	})

	objectMetadata[542] = inherit(objectMetadata[540], {
		name = "Iron Sword",
		sprite = "180c31742ab.png",
		durability = 3080,
		sharpness = 6.5,
		strenght = 3.5
	})

	objectMetadata[543] = inherit(objectMetadata[542], {
		name = "Golden Sword",
		sprite = "",
		durability = 2310,
		sharpness = 5.5,
		cooldown = 250
	})

	objectMetadata[544] = inherit(objectMetadata[542], {
		name = "Diamond Sword",
		sprite = "180c317704a.png",
		durability = 4620,
		sharpness = 7.5,
		strenght = 4
	})

	objectMetadata[550] = {
		name = "Wood Axe",
		sprite = "180c3f5790e.png",
		
		hardness = 0,
		ftype = {
			[1] = 0.75,
			[2] = 0.9,
			[3] = 1.25,
			[4] = 1.75,
			[5] = 0.5,
			[6] = 1.0,
			[7] = 1.0
		},
		
		durability = 680,
		sharpness = 3.5,
		strenght = 3.5,
		
		degradable = true,
		
		cooldown = 250
	}
	
	objectMetadata[551] = inherit(objectMetadata[550], {
		name = "Stone Axe",
		sprite = "180c3f5a161.png",
		durability = 1620,
		sharpness = 4.5,
		strenght = 4.5
	})

	objectMetadata[552] = inherit(objectMetadata[550], {
		name = "Iron Axe",
		sprite = "180c3f5d4ed.png",
		durability = 3240,
		sharpness = 5.5,
		strenght = 5.5
	})

	objectMetadata[554] = inherit(objectMetadata[550], {
		name = "Diamond Axe",
		sprite = "180c3f603e3.png",
		durability = 5670,
		sharpness = 5.5,
		strenght = 5.5
	})

	objectMetadata[560] = {
		name = "Wood Shovel",
		sprite = "180c440fcfb.png",
		hardness = 0,
		ftype = {
			[1] = 3.0,
			[2] = 2.5,
			[3] = 1.0,
			[4] = 0.75,
			[5] = 0.75,
			[6] = 0.6,
			[7] = 0.9
		},
		
		durability = 680,
		sharpness = 32.5,
		strenght = 3.0,
		
		degradable = true,
		
		cooldown = 100
	}
	
	objectMetadata[561] = inherit(objectMetadata[560], {
		name = "Stone Shovel",
		sprite = "180c44126f0.png",
		durability = 1160,
		sharpness = 3.5,
		strenght = 4
	})

	objectMetadata[562] = inherit(objectMetadata[560], {
		name = "Iron Shovel",
		sprite = "180c441536c.png",
		durability = 2320,
		sharpness = 4.5,
		strenght = 5
	})

	objectMetadata[564] = inherit(objectMetadata[560], {
		name = "Diamond Shovel",
		sprite = "180c4417d15.png",
		durability = 4640,
		sharpness = 5.5,
		strenght = 6
	})

	objectMetadata[1024] = {}
end