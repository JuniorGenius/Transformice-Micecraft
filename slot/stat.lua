slotNew = function(id, itemId, stackable, amount, desc, belongsTo)
	local self = {
		id = id,
		itemId = itemId or 0,
		object = nil,
		stackable = stackable or true,
		amount = amount or 0,
		sprite = {},
		stack = belongsTo or "bridge",
		dx = desc.dx,
		dy = desc.dy,
		allowInsert = desc.insert,
		size = desc.size or 32,
		callback = desc.callback or dummyFunc
	}
	
	return self
end

slotFill = function(self, itemId, amount, stackable, object)
	self.itemId = itemId
	self.amount = amount or 1
	self.stackable = stackable == nil and true or stackable

	if object then
		self.object = object
		self.sprite[1] = object.sprite
	else
		self.object = itemNew(itemId)
		
		if itemId ~= 0 then
			self.sprite[1] = objectMetadata[itemId].sprite
		else
			self.sprite[1] = nil
		end
	end
	
	return self
end

slotEmpty = function(self, playerName)
	local item = self
	
	self.itemId = 0
	self.amount = 0
	self.stackable = false
	
	if self.sprite[2] then
		tfm.exec.removeImage(self.sprite[2])
		self.sprite[2] = nil
	end
	
	self.sprite[1] = nil
	
	self.object = nil
	
	ui.removeTextArea(self.id+500, playerName)
	ui.removeTextArea(self.id+650, playerName)
	
	return item
end