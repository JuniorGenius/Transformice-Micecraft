
function _Chunk:load()
	if not self.loaded then
		local _blockDisplay = blockDisplay
		local blockList = self.block
		for y=1, #blockList do
			for x=1, #blockList[1] do
				_blockDisplay(blockList[y][x])
			end
		end

		self.userHandle = unreference(map.userHandle)
		self.loaded = true
		eventChunkLoaded(self)
		map.chunksLoaded = map.chunksLoaded + 1
		return true
	end
end

function _Chunk:unload(onlyVisual)
	if self.loaded then
		local _blockHide = blockHide
		local blockList = self.block
		for y=1, #blockList do
			for x=1, #blockList[1] do
				_blockHide(blockList[y][x])
			end
		end
		
		if self.activated and not onlyVisual then
			self:deactivate()
		end
		
		self.userHandle = unreference(map.userHandle)
		
		self.loaded = false
		eventChunkUnloaded(self)
		map.chunksLoaded = map.chunksLoaded - 1
		return true
	end
	
	return false
end

function _Chunk:reload()
	self:unload(true)
	self:load()
	
	return true
end