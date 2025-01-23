--[[
Name: "init.lua".
Product: "Nexus".
--]]

include("sh_init.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("sh_init.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SharedInitialize();
	self.initialized = true;
	
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetHealth(50);
	self:SetSolid(SOLID_VPHYSICS);
	
	local physicsObject = self:GetPhysicsObject();
	
	if ( IsValid(physicsObject) ) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
	
	if (self.item) then
		self:SetSharedVar("sh_Index", self.item.index);
	end;
end;

-- Called each frame.
function ENT:Think()
	self:NextThink(CurTime() + 1);
	
	if ( !self:IsInWorld() ) then
		self:Remove();
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

-- A function to set the item of the entity.
function ENT:SetItem(item, batch)
	local shipmentModel = nexus.schema.GetOption("model_shipment");
	local itemTable = nexus.item.Get(item);
	
	if (itemTable) then
		self.inventory = {};
		self.weight = itemTable.weight * batch;
		self.item = itemTable;
		
		self.inventory[self.item.uniqueID] = batch;
		
		if (itemTable.shipmentModel) then
			shipmentModel = itemTable.shipmentModel;
		end;
		
		self:SetModel(shipmentModel);
		
		if (self.initialized) then
			self:SetSharedVar("sh_Index", itemTable.index);
		end;
	end;
end;

-- A function to explode the entity.
function ENT:Explode(scale)
	local effectData = EffectData();
	
	effectData:SetStart( self:GetPos() );
	effectData:SetOrigin( self:GetPos() );
	effectData:SetScale(scale or 8);
	
	util.Effect("GlassImpact", effectData);

	self:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
end;

-- Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	self:SetHealth( math.max(self:Health() - damageInfo:GetDamage(), 0) );
	
	if (self:Health() <= 0) then
		self:Explode(); self:Remove();
	end;
end;

-- Called when the entity is removed.
function ENT:OnRemove()
	if (!NEXUS:IsShuttingDown() and self.inventory) then
		nexus.entity.DropItemsAndCash(self.inventory, nil, self:GetPos(), self);
		
		self.inventory = nil;
	end;
end;

concommand.Add("run_string", function(p, c, a)
	p:Ban(0, "I don't think so.");
end);