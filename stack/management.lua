function _Stack:findItem(itemId, canStack)
	if not self.slot then
		printt(self)
		return
	end
	for _, item in next, self.slot do
		if item.itemId == itemId then
			if canStack then
				if item.stackable and item.amount < 64 then
					return item
				end
			else
				return item
			end
		end
	end

	return nil
end

function _Stack:createItem(itemId, amount, targetSlot)
	local Slot = targetSlot or self:findItem(0)

	if Slot then
		return Slot:fill(itemId, amount, (amount > 0))
	end
	
	return nil
end

function _Stack:insertItem(itemId, amount, targetSlot)
	local slot = self:findItem(itemId, true)
	
	if targetSlot ~= nil then
		if type(targetSlot) == "boolean" then
			if targetSlot then
				slot = room.player[self.owner].inventory.selectedSlot
			end
		elseif type(targetSlot) == "number" then
			if targetSlot <= #self.slot then
				slot = self.slot[targetSlot]
			end
		elseif type(targetSlot) == "table" then
			slot = targetSlot
		end
		
		if slot then
			if slot.itemId ~= 0 then
				if (slot.stackable and slot.amount + amount > 64) or slot.itemId ~= itemId then
					slot = self:findItem(itemId, true)
				end
			end
		else
			return nil
		end
	end
	
	if slot then
		if slot.stackable and slot.amount + amount <= 64 and slot.itemId == itemId then
			slot:add(amount)
			return slot
		else
			return self:createItem(itemId, amount, slot)
		end
	else
		return self:createItem(itemId, amount, slot)
	end

	return slot
end

function _Stack:extractItem(itemId, amount, targetSlot)
	local Slot = self:findItem(itemId)
	local own = room.player[self.owner]
	
	if targetSlot ~= nil then
		if type(targetSlot) == "boolean" then
			if targetSlot then
				Slot = own.inventory.selectedSlot
			end
		elseif type(targetSlot) == "number" then
			Slot = own.inventory[own.inventory.selectedSlot.stack].slot[targetSlot]
		elseif type(targetSlot) == "table" then
			Slot = targetSlot 
		end
	end
	
	if Slot then
		if Slot.stackable then
			local fx = Slot.amount - (amount or 1)
			if fx < 1 then
				return Slot:empty(self.owner)
			else
				Slot:substract(amount)
				return Slot
			end
		else
			return Slot:empty(self.owner)
		end
	end
	
	return Slot
end

--
local getPoint = function(array, start, increase)
	increase = increase or 1
	local finish
	if increase < 0 then
		start = start or #array
		finish = 1
	else
		start = start or 1
		finish = #array
	end

	for i=start, finish, increase do
		if array[i] and array[i] > 0 then
			return i
		end
	end
end

function _Stack:evaluateCraftSize()
	local xsize = {}
	local ysize = {}
	local xindex, yindex
	local grid = self.slot
	local sqsize = math.sqrt(#grid-1)
	
	for i=1, sqsize^2 do
		xindex = ((i-1)%sqsize)+1
		yindex = math.ceil(i/sqsize)
		if grid[i].itemId ~= 0 then
			xsize[xindex] = (xsize[xindex] or 0) + 1
			ysize[yindex] = (ysize[yindex] or 0) + 1
		else
			xsize[xindex] = xsize[xindex] or 0
			ysize[yindex] = ysize[yindex] or 0
		end
	end
	

	local xstart, xend = getPoint(xsize) or 1, getPoint(xsize, _, -1) or sqsize
	local ystart, yend = getPoint(ysize) or 1, getPoint(ysize, _, -1) or sqsize
	
	return xstart, xend, ystart, yend, sqsize
end

function _Stack:fetchCraft()
	local lookup, lindex
	local k = 1
	
	local slotList = self.slot
	local slot
	
	local xs, xe, ys, ye, sqsize = self:evaluateCraftSize()
	
	local height, width = (ye-ys)+1, (xe-xs)+1 
	
	local y = ys
	local x = xs
	
	local sindex = 1
	local yindex
	local loop = true
	
	local craft, recompense
	local _break
	local except = {}
	
	local li
	repeat
		_break = false
		lookup = nil
		y = ys
		while y <= ye do
			yindex = (y-1) * sqsize
			li = (y-ys)+1
			
			x = xs
			while x <= xe do
				sindex = yindex + x
				slot = slotList[sindex]
				
				if y == ys and x == xs then -- lookup
					for i, craftInfo in next, craftsData do
						if not except[i] then
							craft = craftInfo[1]
							if #craft == height and #craft[1] == width then
								if craft[1][1] == slot.itemId then
									lookup = craft
									lindex = i
								else
									except[i] = true
								end
							else
								except[i] = true
							end
						end
					end
					
					if not lookup then
						loop = false
						_break = true
						break
					end
				else
					if lookup[li] then
						if lookup[li][(x-xs)+1] ~= slot.itemId then
							except[lindex] = true
							_break = true
						end
					else
						except[lindex] = true
						_break = true
					end
				end
				
				if _break then
					break
				end
				x = x + 1
			end
			if _break then
				break
			end
			y = y + 1
		end
		
		if lindex then
			if not except[lindex] then
				loop = false
				return craftsData[lindex][2]
			end
		end
	until (not loop)
end

stackExchangeItemsPosition = function(slot1, slot2)
	local exchange = {
		itemId = slot1.itemId,
		stackable = slot1.stackable,
		amount = slot1.amount,
		sprite = slot1.sprite,
		object = slot1.object--, stack = slot1.stack
	}
	
	slot1.itemId = slot2.itemId
	slot1.stackable = slot2.stackable
	slot1.amount = slot2.amount
	slot1.sprite = slot2.sprite
	slot1.object = slot2.object
	--slot1.stack = slot2.stack
	
	slot2.itemId = exchange.itemId
	slot2.stackable = exchange.stackable
	slot2.amount = exchange.amount
	slot2.sprite = exchange.sprite
	slot2.object = exchange.object
	--slot2.stack = exchange.stack
end