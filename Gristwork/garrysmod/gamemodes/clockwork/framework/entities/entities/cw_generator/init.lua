--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel(self.Model);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);

	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
	
	local generator = Clockwork.generator:FindByID(
		self:GetClass()
	);
	
	if (generator) then
		self:SetHealth(generator.health);
		self:SetPower(generator.power)
		
		timer.Simple(1, function()
			if (IsValid(self) and self.OnCreated) then
				self:OnCreated();
			end;
		end);
	else
		timer.Simple(1, function()
			if (IsValid(self)) then
				self:Remove();
			end;
		end);
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

-- Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	local generator = Clockwork.generator:FindByID(self:GetClass());
	local attacker = damageInfo:GetAttacker();
	
	if (generator and IsValid(attacker) and attacker:IsPlayer()) then
		if (self.AdjustDamage) then
			self:AdjustDamage(damageInfo);
		end;
		
		if (Clockwork.plugin:Call("PlayerCanDestroyGenerator", attacker, self, generator)
		and damageInfo:GetDamage() > 0) then
			self:SetHealth(math.max(self:Health() - damageInfo:GetDamage(), 0));
			
			if (self:Health() <= 0) then
				if (IsValid(attacker) and attacker:IsPlayer())then
					Clockwork.plugin:Call("PlayerDestroyGenerator", attacker, self, generator);
				end;
				
				if (self.OnDestroy) then
					self:OnDestroy(attacker, damageInfo);
				end;
				
				self:Explode();
				self:Remove();
			end;
		end;
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