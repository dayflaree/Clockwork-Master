// Dummy entity for preventing missing entity errors

ENT.Type = "anim"  
ENT.Base = "base_anim"    

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )

	function ENT:Initialize()
		self:SetMoveType( MOVETYPE_NONE )
		self:SetNotSolid( true )
		self:SetNoDraw( true )
	end
else
	function ENT:Draw()
	end
end
