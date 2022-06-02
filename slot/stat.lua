_Slot.new = function(id, itemId, stackable, amount, desc, belongsTo)
	local self = setmetatable({}, _Slot)
	
	self.id = id
	self.itemId = itemId or 0
	
	self.object = nil
	
	self.stackable = stackable or true
	self.amount = amount or 0
	
	self.sprite = {}
	self.dx = desc.dx
	self.dy = desc.dy
	self.size = desc.size or 32
	
	self.stack = belongsTo or "bridge"
	self.allowInsert = desc.insert

	self.callback = desc.callback or dummyFunc
	
	return self
end

function _Slot:fill(itemId, amount, stackable, object)
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

function _Slot:empty(playerName)
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
	
	return self
end