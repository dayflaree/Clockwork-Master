AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
RandomCrateItems = {}
RandomCrateItems[1] = "
RandomCrateItems[2] =
function ENT:Initialize()
	self.Entity:SetModel("models/props_junk/wood_crate001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetName( "Crate" ) --Sets the name of this object for no tool or phys later. ;)
	SetGlobalInt( "crates", GetGlobalInt( "crates" ) + 1 )
	self.Entity:SetNWInt( "searched", 0 )
	local phys = self.Entity:GetPhysicsObject()

	if phys and phys:IsValid() then phys:Wake() end

end


function ENT:Use( activator, caller )
	
	--self.Entity:GetNWString( "letter" )
end

function ENT:StartTouch()
end

function ENT:EndTouch()
end

function ENT:OnRemove()
	SetGlobalInt( "crates", GetGlobalInt( "crates" ) - 1 )
end


