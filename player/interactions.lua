function _Player:placeObject(x, y, ghost)
	if withinRange(x, y) then
		local Slot = self.inventory.selectedSlot
		
		if Slot.amount >= 1 then
			local _getPosBlock = getPosBlock
			local Block = _getPosBlock(x, y - worldVerticalOffset)
			
			if Block.type == 0 then
				local dist = distance(
					self.x, self.y,
					Block.dx+blockHalf, Block.dy+blockHalf
				)
				
				if dist <= self.prange then
					local blockList = getBlocksAround(Block, false, true)
					local hasBlockAround = false
					for _, block in next, blockList do
						if block.type ~= 0 then
							hasBlockAround = true
						end
					end
					
					if hasBlockAround then
						local item = Slot.itemId
						local ref = self:inventoryExtract(Slot.itemId, 1, true, Slot)
						
						if ref then
							blockCreate(Block, item, ghost, true)
							self:actualizeHoldingItem()
							
							if ref.stack == "invbar" then
								Slot:refresh(self.name, 0, 0)
							end
						end
					end
				end
			end
		end
	end
end

function _Player:destroyBlock(x, y)
	if withinRange(x, y) then
		local Block = getPosBlock(x, y - worldVerticalOffset)
		
		if Block.type ~= 0 then
			local dist = distance(
				self.x, self.y,
				Block.dx + blockHalf, Block.dy + blockHalf
			)
			
			if dist <= self.prange then
				local blockList = getBlocksAround(Block, false, true)
				local isOpen = false
				
				for _, block in next, blockList do
					if block.ghost then
						isOpen = true
					end
				end
				
				if isOpen then
					local Slot = self.inventory.selectedSlot
					local drop = itemDealBlockDamage(Slot.object, Block)
					
					if drop ~= 0 then
						if Block.type == 0 then
							local ref = self:inventoryInsert(drop, 1, "invbar", true)
							if ref then
								self:actualizeHoldingItem()
								if Slot.stack == "invbar" then
									Slot:refresh(self.name, 0, 0)
								end
							end
						end
					end
				end
			end
		end
	end
end

function _Player:initTrade(whom, activate)
	if whom and self ~= whom then
		self.trade.whom = whom
		self.trade.timestamp = os.time()
		self.trade.isActive = activate or false
	end
end

function _Player:cancelTrade()
	self.trade.whom = nil
	self.trade.timestamp = os.time()
	self.trade.isActive = false
end

function _Player:blockInteract(Block)
	if Block.type ~= 0 then
		if Block.interact then
			blockInteract(Block, self)
		else
			self:alertMessage(objectMetadata[Block.type].name, 328, "D", 14)
		end
	end
end