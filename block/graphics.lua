local _tfm_exec_addImage = tfm.exec.addImage
local blockDisplay = function(self)
	if self.type ~= 0 then
		local _addImage = _tfm_exec_addImage
		local sprite = self.sprite[1]
		self.sprite[2] = {
			_addImage(sprite[1], "_1", self.dx, self.dy, nil, 1.0, 1.0, 0, 1.0, 0, 0),
			nil, -- self.mossy and _addImage(sprite[2], "_2", self.dx, self.dy, nil, 1.0, 1.0, 0, 1.0, 0, 0) or nil,
			self.translucent and nil or _addImage(sprite[3], "_3", self.dx, self.dy, nil, 1.0, 1.0, 0, self.shadowness, 0, 0), -- self.shadowness*self.alpha
			self.damage > 0 and _addImage(sprite[4], "_4", self.dx, self.dy, nil, 1.0, 1.0, 0, 1.0, 0, 0) or nil
		}
	end
end

local _tfm_exec_removeImage = tfm.exec.removeImage

local blockHide = function(self)
	if self.type > 0 then
		local _removeImage = _tfm_exec_removeImage
		local sprite = self.sprite[2]
		for k=1, 4 do
			if sprite[k] then 
				_removeImage(sprite[k])
				sprite[k] = nil
			end
		end
	end
end