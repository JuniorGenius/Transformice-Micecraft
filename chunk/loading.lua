chunkLoad = function(self)
	if not self.loaded then
		local _blockDisplay = blockDisplay
		for i=1, 32 do
			for j=1, 12 do
				_blockDisplay(self.block[i][j])
			end
		end
		
		self.loaded = true
		return true
	end
end

chunkUnload = function(self, onlyVisual)
	local _blockHide = blockHide 
	if self.loaded then
		for i=1, 32 do
			for j=1, 12 do
				_blockHide(self.block[i][j])
			end
		end
		if self.activated and not OnlyVisual then chunkDeactivate(self) end
		self.loaded = false
		return true
	end
	
	return false
end

chunkReload = function(self)
	chunkUnload(self, true)
	chunkLoad(self)
	
	return true
end