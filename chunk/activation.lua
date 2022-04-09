chunkActivateSegment = function(self, seg)
	local obj = self.grounds[1][seg]
	if obj then
		addPhysicObject(obj.id, obj.xPos, obj.yPos, obj.bodydef)
		self.grounds[2][seg] = obj.id
	end
end

chunkActivateSegRange = function(self, segList)
	local _chunkActivateSegment = chunkActivateSegment
	for _, seg in next, segList do
		_chunkActivateSegment(self, seg)
	end
end

chunkDeactivateSegment = function(self, seg)
	if seg > 0 then
		if self.grounds[2][seg] then
			removePhysicObject(self.grounds[2][seg])
		end
		self.grounds[2][seg] = nil
	end
end

chunkDeleteSegment = function(self, seg)
	if seg > 0 then
		if self.grounds[1][seg] then
			local block
			local limits = self.grounds[1][seg]
			_table_extract(self.segments, seg)
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
			
			self.grounds[1][seg] = {}
		end
	end
end

chunkRefreshSegment = function(self, seg)
	chunkDeactivateSegment(self, seg)
	chunkDeleteSegment(self, seg)
	local actList = chunkCalculateCollisions(self)
	chunkActivateSegRange(self, actList)
	
	return true
end

chunkRefreshSegList = function(self, blockList)
	local block
	
	for _, block in next, blockList do		
		if block.chunk == self.id then
			chunkDeactivateSegment(self, block.act)
			chunkDeleteSegment(self, block.act)
		end
	end

	local actList = chunkCalculateCollisions(self)
	chunkActivateSegRange(self, actList)
	
	return true
end

chunkActivate = function(self, onlyPhysics) 
	if not self.activated then
		if os.time() > self.timestamp + 4000 then				
			local _chunkActivateSegment = chunkActivateSegment
			local grounds = self.grounds[1]
			for _, seg in next, self.segments do
				if grounds[seg] then
					_chunkActivateSegment(self, seg)
				end
			end
		
			if not self.loaded and not onlyPhysics then chunkLoad(self) end
			self.activated = true
			self.timestamp = os.time()
			return true
		end
	end
	
	return false
end

chunkDeactivate = function(self)
	if self.activated then
		if os.time() > self.timestamp + 4000 then
			local _chunkDeactivateSegment = chunkDeactivateSegment
			local grounds = self.grounds[1]
			for _, seg in next, self.segments do
				if grounds[seg] then
					chunkDeactivateSegment(self, seg)
				end
			end

			self.activated = false
			
			return true
		end
	end
	
	return false
end

chunkDelete = function(self)
	local _chunkDeleteSegment = chunkDeleteSegment
	for _, seg in next, self.segments do
		_chunkDeleteSegment(self, seg)
	end
	
	return true
end

chunkRefresh = function(self, update)
	chunkDeactivate(self)
	if update then
		chunkDelete(self)
		chunkCalculateCollisions(self)
	end
	chunkActivate(self, true)
	
	return true
end

chunkFlush = function(self)
	chunkUnload(self)
	chunkActivate(self)
	
	return true
end

chunkUpdate = function(self, onlyPhysic, onlyVisual)
	local cc = 0
	if onlyPhysic and onlyVisual == false then
		cc = cc + (chunkRefresh(self) and 1 or 0)
	elseif onlyVisual and onlyPhysic == false then
		cc = cc + (chunkReload(self) and 1 or 0)
	elseif onlyPhysic == false and onlyVisual == false then
		cc = cc + (chunkFlush(self) and 1 or 0)
	elseif onlyPhysic == nil and onlyVisual == nil then
		cc = cc + (chunkLoad(self) and 1 or 0)
		cc = cc + (chunkActivate(self, true) and 1 or 0)
	end
	
	return cc >= 1
end 