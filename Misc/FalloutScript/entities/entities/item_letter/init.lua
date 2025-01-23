AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self.Entity:SetModel("models/props_c17/paper01.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	local ply = self.Entity:GetNWEntity("OLetterOwner")
	ply:SetNWInt("maxoletters", ply:GetNWInt("maxoletters") + 1)
	if phys and phys:IsValid() then phys:Wake() end

end


function ENT:Use( activator, caller )
end

function ENT:StartTouch()
end

function ENT:EndTouch()
end

function ENT:OnRemove()
	local ply = self.Entity:GetNWEntity("OLetterOwner")
	ply:SetNWInt("maxoletters", ply:GetNWInt("maxoletters") - 1)
end


