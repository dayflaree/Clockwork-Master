// Armor pickup

ENT.Type = "anim"
ENT.Base = "base_pickup"

ENT.Model = "models/props/pickups/armorpickup.mdl"

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	
	function ENT:PlayerPickup( ply )
		if ( ply:Armor() < ply.Class.Armor ) then
			ply:EmitSound( "player/pickup.wav", 100, 100 )
			ply:SetArmor( math.min( ply:Armor() + 50, ply.Class.Armor ) )
			
			return true
		end
	end
end