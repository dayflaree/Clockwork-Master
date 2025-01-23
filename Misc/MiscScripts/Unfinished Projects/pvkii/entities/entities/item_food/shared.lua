// Health pickup

ENT.Type = "anim"
ENT.Base = "base_pickup"

ENT.Model = "models/props/pickups/healthpickup.mdl"

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	
	function ENT:PlayerPickup( ply )
		if ( ply:Health() < ply.Class.Health ) then
			ply:EmitSound( table.Random( ply.Class.EatSounds ), 100, 100 )
			ply:SetHealth( math.min( ply:Health() + 50, ply.Class.Health ) )
			
			return true
		end
	end
end