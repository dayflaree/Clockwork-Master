AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetModel("models/pg_props/pg_obj/pg_glow_stick.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
end;

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create("cw_glowstick_green_fly")
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()
    ent:Activate()
    return ent
end;

ents.Create("prop_physics")

function ENT:OnTakeDamage(dmg)
	self.Entity:Remove()
end

function ENT:Use()
	self.Entity:Remove()
end;