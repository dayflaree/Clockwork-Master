// Ammo pickup

ENT.Type = "anim"
ENT.Base = "base_pickup"

ENT.Model = "models/props/pickups/ammopickup.mdl"

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	
	function ENT:PlayerPickup( ply )
		ply:EmitSound( "player/pickup.wav", 100, 100 )
		ply:Give( "weapon_smg1" )
		ply:GiveAmmo( 30, "SMG1", true )
		
		return true
	end
end