AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS)
	self.Entity:SetSolid( SOLID_VPHYSICS)

	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then
		phys:Wake()
	end
	--phys:SetMass( itemtable.Weight )
	
end

function ENT:Touch( hitEnt )
   
end