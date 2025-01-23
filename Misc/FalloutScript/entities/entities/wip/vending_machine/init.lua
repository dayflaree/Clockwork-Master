AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "sent_ball" )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:Initialize()

	self.Entity:SetModel("models/props_interiors/VendingMachineSoda01a.mdl")

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	--self.Entity:SetPos( Vector( 3667.750000, 2543.968750, -12199.968750 ) )
	--self.Entity:SetAngles( Angle( 0, -90, 0 ) )
	
end

function ENT:Use( activator, caller )
	
	LEMON.CreateItem( "drink_nukacola", self.Entity:GetPos() + Vector( 15, -4, -20 ), Angle( 0, 0, 90 ) )

	timer.Create( "vended", 10, 0, function()
		timer.Stop( "vended" )
	end )

end


function ENT:Think()
	return true
end
