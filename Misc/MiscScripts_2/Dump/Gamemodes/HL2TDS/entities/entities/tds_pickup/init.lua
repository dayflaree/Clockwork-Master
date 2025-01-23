AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/healthvial.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
end

function ENT:Touch(ent)
	if not ent:IsPlayer() then return end
	ent:SetHealth(ent:Health() + 10)
	self:Remove()
end
