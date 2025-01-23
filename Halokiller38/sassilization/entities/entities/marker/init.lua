AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( 'shared.lua' );

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize( )
	local iRadius = 4
	self.Entity:PhysicsInit( 0 )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:DrawShadow( false )
end