
function _Chunk:activateSegment(segment)
	local obj = self.grounds[1][segment]
	if obj then
		addPhysicObject(obj.id, obj.xPos, obj.yPos, obj.bodydef)
		self.grounds[2][segment] = obj.id
	end
end

function _Chunk:activateSegRange(segList)
	for _, segment in next, segList do
		self:activateSegment(segment)
	end
end

function _Chunk:deactivateSegment(segment)
	if segment > 0 then
		if self.grounds[2][segment] then
			removePhysicObject(self.grounds[2][segment])
		end
		self.grounds[2][segment] = nil
	end
end

function _Chunk:deleteSegment(segment)
	if segment > 0 then
		if self.grounds[1][segment] then
			local block
			local limits = self.grounds[1][segment]
			_table_extract(self.segments, segment)
			for y=limits.startPoint[2], limits.endPoint[2] do
				for x=limits.startPoint[1], limits.endPoint[1] do
					block = self.block[y][x]
					if block.type == 0 or block.ghost then
						block.act = 0
					else
						block.act = -1
					end
				end
			end
			
			self.grounds[1][segment] = {}
		end
	end
end

function _Chunk:refreshSegment(segment)
	self:deactivateSegment(segment)
	self:deleteSegment(segment)
	local actList = self:calculateCollisions()
	self:activateSegRange(actList)
	
	return true
end

function _Chunk:refreshSegList(blockList)
	local block
	
	for _, block in next, blockList do		
		if block.chunk == self.id then
			self:deactivateSegment(block.act)
			self:deleteSegment(block.act)
		end
	end

	local actList = self:calculateCollisions()
	self:activateSegRange(actList)
	
	return true
end

function _Chunk:activate(onlyPhysics)
	if not self.activated then
		if os.time() > self.timestamp then
			local grounds = self.grounds[1]
			for _, segment in next, self.segments do
				if grounds[segment] then
					self:activateSegment(segment)
				end
			end
		
			if not self.loaded and not onlyPhysics then
				self:load()
			end
			
			self.userHandle = unreference(map.userHandle)
			self.activated = true
			eventChunkActivated(self)
			self.timestamp = os.time() + 4000
			
			map.chunksActivated = map.chunksActivated + 1
			return true
		end
	end
	
	return false
end

function _Chunk:deactivate()
	if self.activated then
		if os.time() > self.timestamp then
			local grounds = self.grounds[1]
			for _, segment in next, self.segments do
				if grounds[segment] then
					self:deactivateSegment(segment)
				end
			end
			
			self.userHandle = unreference(map.userHandle)

			self.activated = false
			eventChunkDeactivated(self)
			map.chunksActivated = map.chunksActivated - 1
			return true
		end
	end
	
	return false
end

function _Chunk:delete()
	for _, segment in next, self.segments do
		self:deleteSegment(segment)
	end
	
	return true
end

function _Chunk:refresh(shouldUpdate)
	self:deactivate()
	if shouldUpdate then
		self:delete()
		self:calculateCollisions()
	end
	self:activate(true)
	
	return true
end

function _Chunk:flush()
	self:unload()
	self:activate()
	
	return true
end

function _Chunk:update(onlyPhysic, onlyVisual)
	local cc = 0
	if onlyPhysic and onlyVisual == false then
		cc = cc + (self:refresh() and 1 or 0)
	elseif onlyVisual and onlyPhysic == false then
		cc = cc + (self:reload() and 1 or 0)
	elseif onlyPhysic == false and onlyVisual == false then
		cc = cc + (self:flush() and 1 or 0)
	elseif onlyPhysic == nil and onlyVisual == nil then
		cc = cc + (self:load() and 1 or 0)
		cc = cc + (self:activate(true) and 1 or 0)
	end
	
	return cc >= 1
end 