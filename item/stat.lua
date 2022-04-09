itemNew = function(id, itemId, stackable, amount, desc, belongsTo)
	local self = {
		id = id,
		itemId = itemId or 0,
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

itemCreate = function(self, itemId, amount, stackable)
	self.itemId = itemId
	self.amount = amount or 1
	self.stackable = stackable or true
	self.sprite[1] = itemId ~= 0 and objectMetadata[itemId].sprite or nil
	
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
	
	ui.removeTextArea(self.id+500, playerName)
	ui.removeTextArea(self.id+650, playerName)
	
	return item
end