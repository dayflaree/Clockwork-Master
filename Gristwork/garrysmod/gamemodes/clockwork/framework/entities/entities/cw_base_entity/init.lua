
include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetHealth(25);
	self:SetSolid(SOLID_VPHYSICS);
	
	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_PVS;
end;

-- A function to get the entity's item table.
function ENT:GetItemTable()
	return self.cwItemTable;
end;

-- A function to set the item of the entity.
function ENT:SetItemTable(itemTable)
	if (itemTable) then
		self:SetSkin(itemTable("skin", 1));
		self:SetModel(itemTable("model"));
		
		if (itemTable.OnCreated) then
			itemTable:OnCreated(self);
		end;
		
		self.cwItemTable = itemTable;
		
		Clockwork.item:RemoveItemEntity(self);
		Clockwork.item:AddItemEntity(self, itemTable);
	end;
end;

-- Called when the entity is removed.
function ENT:OnRemove()
	local itemTable = self.cwItemTable;
	
	if (itemTable and itemTable.OnEntityRemoved) then
		itemTable:OnEntityRemoved(self);
	end;
end;

-- A function to explode the entity.
function ENT:Explode()
	local effectData = EffectData();
		effectData:SetStart(self:GetPos());
		effectData:SetOrigin(self:GetPos());
		effectData:SetScale(8);
	util.Effect("GlassImpact", effectData, true, true);

	self:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
end;

-- Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	local itemTable = self.cwItemTable;

	if (itemTable) then	
		if (itemTable.OnEntityTakeDamage
		and itemTable:OnEntityTakeDamage(self, damageInfo) == false) then
			return;
		end;
		
		Clockwork.plugin:Call("ItemEntityTakeDamage", self, itemTable, damageInfo);
		
		if (damageInfo:GetDamage() > 0) then
			self:SetHealth(math.max(self:Health() - damageInfo:GetDamage(), 0));
			
			if (self:Health() <= 0) then
				if (itemTable.OnEntityDestroyed and itemTable:OnEntityDestroyed(self)) then
					return;
				end;
				
				Clockwork.plugin:Call("ItemEntityDestroyed", self, itemTable);
				self:Explode();
				self:Remove();
			end;
		end;
	end;
end;

-- Called each frame.
function ENT:Think()
	local itemTable = self.cwItemTable;
	
	if (itemTable and itemTable.OnEntityThink) then
		local nextThink = itemTable:OnEntityThink(self);
		
		if (type(nextThink) == "number") then
			self:NextThink(CurTime() + nextThink);
			return true;
		end;
	end;
end;

-- Called when the entity starts touching another entity.
function ENT:StartTouch(entity)
	local itemTable = self.cwItemTable;
	
	if (itemTable and itemTable.OnEntityStartTouch) then
		itemTable:OnEntityStartTouch(self, entity);
	end;
end;

-- Called when the entity stops touching another entity.
function ENT:EndTouch(entity)
	local itemTable = self.cwItemTable;
	
	if (itemTable and itemTable.OnEntityEndTouch) then
		itemTable:OnEntityEndTouch(self, entity);
	end;
end;