itemCheckStatus = function(self)
    if self.degradable then
        if self.damage <= 0 then
            return itemDelete(self)
        end
    end
end

itemDealBlockDamage = function(self, Block)
    local damage, drop = 2, 0
    
    if Block.type < 512 then
		if self then
            
			if self.strenght ~= 0 then
				local ft = Block.ftype
				
				local multiplier = 1.0
				if type(self.ftype) == "table" then
					multiplier = self.ftype[ft] or self.ftype[0] or 1.0
				end
				damage = (self.strenght or 1) * multiplier
			end
			
			if self.degradable then
				self.damage = self.damage - 1
			
				itemCheckStatus(self)
			end
            
            if self.hardness >= Block.hardness then
                drop = Block.drop
            end
		else
			if Block.hardness == 0 then
				drop = Block.drop
			end
		end

        local destroyed = blockDamage(Block, damage)
        if not destroyed then
            drop = 0
        end
    end
    
    return drop
end
itemDealEntityDamage = function(self, Entity)
    local damage = 2
    local Perpetrator = room.player[self.owner]
    if Entity.isAlive then
        if self.sharpness ~= 0 then
            damage = self.sharpness
        end
        
        if self.degradable then
            self.damage = self.damage - 8
            
            itemCheckStatus(self)
        end
        
        return Perpetrator:dealEntityDamage(Entity, damage)
    end
end
