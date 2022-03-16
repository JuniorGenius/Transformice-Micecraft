itemNew = function(id, itemId, stackable, amount, interact)
	local self = {
		id = id,
		itemId = itemId or 0,
		stackable = stackable or true,
		amount = amount or 0,
		sprite = {},
		dx = interact and {} or 245+(34*((id-1)%9))+10,
		dy = interact and {} or 209+(34*(math.floor((id-1)/9))) + (id > 27 and 16 or 10)
	}
	
	if interact then
		self.dx = {
			craft = {
				[4] = 245 + (id <= 104 and 170 + (34*((id-101)%2)) or 277),
				[9] = 245 + (id <= 109 and 57 + (34*((id-101)%3)) or 213)
			},
			furnace = 245 + (id <= 102 and 99 or 196 + 3)
		}
		self.dy = {
			craft = {
				[4] = 42 + (id <= 104 and 46 + (34*math.floor((id-101)/2)) or 62),
				[9] = 42 + (id <= 109 and 42 + (34*math.floor((id-101)/3)) or 71)
			},
			furnace = 42 + (id <= 102 and 36 + (id == 2 and 68 or 0) or 65 + 3)
		}
	end
	
	return self
end

itemCreate = function(self, itemId, amount, stackable)
	self.itemId = itemId
	self.amount = amount or 1
	self.stackable = stackable or true
	self.sprite[1] = itemId ~= 0 and blockMetadata[itemId].sprite or nil
	
	return self
end

itemRemove = function(self, playerName)
	local item = self
	
	self.itemId = 0
	self.amount = 0
	self.stackable = false
	
	if self.sprite[2] then tfm.exec.removeImage(self.sprite[2]) end
	self.sprite[1] = nil
	self.sprite[2] = nil
	
	ui.removeTextArea(self.id+60, playerName)
	
	return item
end