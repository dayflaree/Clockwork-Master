--[[
Name: "sv_auto.lua".
Product: "HL2 RP".
--]]

NEXUS:IncludePrefixed("sh_auto.lua");

AddCSLuaFile("cl_auto.lua");
AddCSLuaFile("sh_auto.lua");

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 50
	local ent = ents.Create( self.ClassName )
	
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

-- Called when the entity initializes.
function ENT:Initialize()
	self:SharedInitialize();
	
	self.Entity:SetModel("models/fallout3/vendingmachine01.mdl")
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE);
	
	local physicsObject = self:GetPhysicsObject();
	
	if ( IsValid(physicsObject) ) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

-- Called each frame.
function ENT:Think()
	if ( IsValid(self.entity) ) then	
	
	self:NextThink(CurTime() + 0.2);
	end;
end;

-- A function to emit a random sound from the entity.
function ENT:EmitRandomSound()
	local randomSounds = {
		"buttons/combine_button1.wav",
		"buttons/combine_button2.wav",
		"buttons/combine_button3.wav",
		"buttons/combine_button5.wav",
		"buttons/combine_button7.wav"
	};
	local randomSound = randomSounds[ math.random(1, #randomSounds) ];
	
	if (self.entities) then
		
		for k, v in ipairs(self.entities) do
			if ( IsValid(v) ) then
				v:EmitSound(randomSound);
			end;
		end;
	end;
	
	self:EmitSound(randomSound);
end;

-- A function to explode the entity.
function ENT:Explode()
	local effectData = EffectData();
	
	effectData:SetStart( self:GetPos() );
	effectData:SetOrigin( self:GetPos() );
	effectData:SetScale(1);
	
	util.Effect("Explosion", effectData, true, true);
	
	self:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
end;

-- Called when the entity is removed.
function ENT:OnRemove()
	self:Explode();
end;

-- A function to toggle the entity with checks.
function ENT:ToggleWithChecks(activator, player)
	local curTime = CurTime();
	
	if (!self.nextUse or curTime >= self.nextUse) then
		if (NEXUS.player.GetCash(activator) > 8) then
			NEXUS.player.GiveCash(activator, -22, "You have paid 22 caps for a drink from the vending machine.");
			activator:UpdateInventory("drink_nukacola", 1, true, true);
			self:EmitSound("hgn/fallout/obj/drs_nukacolamachine_close.mp3");
			self.nextUse = curTime + 10;
		else
			NEXUS.player.Notify(activator, "You do not have enough Caps!.");
		end;
	end;
end;

-- Called when the entity is used.
function ENT:Use(activator, caller)
	if (activator:IsPlayer() and activator:GetEyeTraceNoCursor().Entity == self) then
		self:ToggleWithChecks(activator);
	end;
end;

-- Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	self:SetHealth( math.max(self:Health() - damageInfo:GetDamage(), 0) );
	
	if (self:Health() <= 0) then
		self:ActivateSmokeCharge(damageInfo:GetDamageForce() * 8);
	end;
end;

-- Called when a player attempts to use a tool.
function ENT:CanTool(player, trace, tool)
	return false;
end;