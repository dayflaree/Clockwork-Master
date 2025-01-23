AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( "shared.lua" )

function ENT:SpawnFunction( ply, tr )	
	local ent = ents.Create( "3dtext" )
	ent:SetPos( tr.HitPos + Vector( 0, 0, 50 ) )
	ent:SetAngles( Angle( 0, 180, 90 ) )
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:Initialize( )
	self.Entity:SetModel( "models/dav0r/tnt/tnt.mdl" )
	self.Entity:DrawShadow( false )
	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	if ( phys:IsValid() ) then
		phys:Wake()
	end
end