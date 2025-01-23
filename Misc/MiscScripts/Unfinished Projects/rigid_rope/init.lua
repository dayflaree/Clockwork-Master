/*-------------------------------------------------------------------------------------------------------------------------
	Rigid rope
-------------------------------------------------------------------------------------------------------------------------*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:SpawnFunction( ply, tr )
	if ( !tr.HitWorld ) then return end
	
	local ent = ents.Create( "rigid_rope" )
	ent:SetPos( tr.HitPos + Vector( 0, 0, 8 ) )
	ent:Spawn()
	ent:DrawShadow( false )
	
	return ent
end

function ENT:Initialize()	
	self.Plug1 = ents.Create( "prop_physics" )
	self.Plug1:SetPos( self:GetPos() )
	self.Plug1:SetAngles( Angle( 0, 0, 0 ) )
	self.Plug1:SetModel( "models/props_lab/tpplug.mdl" )
	self.Plug1:Spawn()
	self.Plug1:GetPhysicsObject():Wake()
	
	self.Plug2 = ents.Create( "prop_physics" )
	self.Plug2:SetAngles( Angle( 0, 0, 0 ) )
	self.Plug2:SetPos( self:GetPos() + Vector( math.random( 32, 64 ), math.random( 32, 64 ), math.random( 0, 8 ) ) )
	self.Plug2:SetModel( "models/props_lab/tpplug.mdl" )
	self.Plug2:Spawn()
	self.Plug2:GetPhysicsObject():Wake()
	
	self:SetDTEntity( 0, self.Plug1 )
	self:SetDTEntity( 1, self.Plug2 )
	
	self:SetParent( self.Plug1 )
	
	local constraint, ent = constraint.Rope( self.Plug1, self.Plug2, 0, 0, Vector( 11.5, 0, 0 ), Vector( 11.5, 0, 0 ), 64, 0, 0, 1.3, "cable/cable2", false )
	ent:Remove()
end

function ENT:OnRemove()
	self.Plug1:Remove()
	self.Plug2:Remove()
end