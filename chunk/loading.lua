chunkLoad = function(self)
	if not self.loaded then
		local _blockDisplay = blockDisplay
		for i=1, 32 do
			for j=1, 12 do
				_blockDisplay(self.block[i][j])
			end
		end

		self.userHandle = unreference(map.userHandle)
		self.loaded = true
		eventChunkLoaded(self)
		map.chunksLoaded = map.chunksLoaded + 1
		return true
	end
end

chunkUnload = function(self, onlyVisual)
	if self.loaded then
		local _blockHide = blockHide 
		for i=1, 32 do
			for j=1, 12 do
				_blockHide(self.block[i][j])
			end
		end
		
		if self.activated and not onlyVisual then
			chunkDeactivate(self)
		end
		
		self.userHandle = unreference(map.userHandle)
		
		self.loaded = false
		eventChunkUnloaded(self)
		map.chunksLoaded = map.chunksLoaded - 1
		return true
	end
	
	return false
end

chunkReload = function(self)
	chunkUnload(self, true)
	chunkLoad(self)
	
	return true
end