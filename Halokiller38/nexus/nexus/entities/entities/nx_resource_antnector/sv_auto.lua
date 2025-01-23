--[[
Name: "sv_auto.lua".
Product: "FalloutRP".
--]]

NEXUS:IncludePrefixed("sh_auto.lua");

AddCSLuaFile("cl_auto.lua");
AddCSLuaFile("sh_auto.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_hive/nest_med_flat.mdl");
	
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

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create( self.ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

-- Called each frame.
function ENT:Think()
	--self:EmitSound("hgn/fallout/obj/obj_computerterminal_01_lp.mp3", 50, 100);
	if ( IsValid(self.entity) ) then	
	self:NextThink(CurTime() + 0.2);
	end;
	if ( !self:IsInWorld() ) then
		self:Remove();
	end;
end;

-- A function to toggle the entity with checks.
function ENT:ToggleWithChecks(activator, player)
	local curTime = CurTime();
	
	if (!self.nextUse or curTime >= self.nextUse) then
			self:EmitSound("hgn/fallout/ui/ui_menu_ok.mp3");
			NEXUS.player.Notify(activator, "Harvested one Ant Nectar.");
			activator:UpdateInventory("food_antnectar", 1, true)
			self.nextUse = curTime + 6000;
	else
		NEXUS.player.Notify(activator, "Nothing of value was found!");
	end;
end;

-- Called when the entity is used.
function ENT:Use(activator, caller)
	if (activator:IsPlayer() and activator:GetEyeTraceNoCursor().Entity == self) then
		self:ToggleWithChecks(activator);
	end;
end;