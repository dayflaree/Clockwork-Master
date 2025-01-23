AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetParent( ply )
	
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_NONE )
	self:DrawShadow( false )
end

function ENT:Think()
	if ( !IsValid( self:GetOwner() ) ) then self:Remove() end
	if ( self:GetOwner():GetNWInt( "STORE_HAT" ) != self.hat ) then
		self.hat = self:GetOwner():GetNWInt( "STORE_HAT" )
		self:SetModel( store.hats[self.hat] and store.hats[self.hat].model or "" )
	end
end