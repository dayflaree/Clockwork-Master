--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/leak_props/props_borealis/borealis_lever001.mdl");
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	
	self.tube = ents.Create("prop_dynamic");
	self.tube:DrawShadow(false);
	self.tube:SetAngles( self:GetAngles() + Angle(0,90,0));
	self.tube:SetParent(self);
	self.tube:SetModel("models/mechanics/solid_steel/box_beam_4.mdl");
	self.tube:SetMaterial("models/props_pipes/GutterMetal01a");
	self.tube:SetPos( self:GetPos() + Vector(-16,0,-6));
	self.tube:Spawn();

	self.tube1 = ents.Create("prop_dynamic");
	self.tube1:DrawShadow(false);
	self.tube1:SetAngles( self:GetAngles() + Angle(0,90,0));
	self.tube1:SetParent(self);
	self.tube1:SetModel("models/mechanics/solid_steel/box_beam_4.mdl");
	self.tube1:SetMaterial("models/props_pipes/GutterMetal01a");
	self.tube1:SetPos( self:GetPos() + Vector(-63,0,-6));
	self.tube1:Spawn();
	
	self.tube2 = ents.Create("prop_dynamic");
	self.tube2:DrawShadow(false);
	self.tube2:SetAngles( self:GetAngles() + Angle(0,90,0));
	self.tube2:SetParent(self);
	self.tube2:SetModel("models/mechanics/solid_steel/box_beam_4.mdl");
	self.tube2:SetMaterial("models/props_pipes/GutterMetal01a");
	self.tube2:SetPos( self:GetPos() + Vector(-110,0,-6));
	self.tube2:Spawn();
	
	self.tube3 = ents.Create("prop_dynamic");
	self.tube3:DrawShadow(false);
	self.tube3:SetAngles( self:GetAngles() + Angle(0,90,0));
	self.tube3:SetParent(self);
	self.tube3:SetModel("models/mechanics/solid_steel/box_beam_4.mdl");
	self.tube3:SetMaterial("models/props_pipes/GutterMetal01a");
	self.tube3:SetPos( self:GetPos() + Vector(-157,0,-6));
	self.tube3:Spawn();

	self:DeleteOnRemove(self.tube);
		
	self:SetCollisionGroup(COLLISION_GROUP_WORLD);
	
	local phys = self:GetPhysicsObject()
	phys:SetMass( 120 )
	
	self:SetSpawnType(1);
end;

function ENT:SetSpawnType(entType)
	if (entType == TYPE_WATERCAN or entType == TYPE_SUPPLIES) then
		self:SetDTInt(1,entType);
	end;
end;

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:EmitRandomSound()
	local randomSounds = {
		"ambient/machines/combine_terminal_idle2.wav",
		"buttons/button4.wav"
	};
	
	self:EmitSound( randomSounds[ math.random(1, #randomSounds) ] );
end;

function ENT:PhysicsUpdate(physicsObject)
	if (!self:IsPlayerHolding() and !self:IsConstrained()) then
		physicsObject:SetVelocity( Vector(0, 0, 0) );
		physicsObject:Sleep();
	end;
end;

function ENT:Use(activator, caller)
	if (activator:IsPlayer() and activator:GetEyeTraceNoCursor().Entity == self) then
		local curTime = CurTime();
		
		if (!self.nextUse or curTime >= self.nextUse) then
			self:EmitRandomSound();
			
			self:SpawnItem(activator);
			
			self.nextUse = curTime + 5;
		else
			self:EmitSound("buttons/button11.wav");
		end;
	end;
end;

function ENT:SpawnItem(activator)
	if (self:GetSpawnType() == TYPE_WATERCAN) then
		Clockwork.entity:CreateItem( activator, "breens_water", self.tube:GetPos());
	else
		Clockwork.entity:CreateItem( activator, "citizen_supplements", self:GetPos());
	end;
end;

function ENT:CanTool(player, trace, tool)
	return false;
end;