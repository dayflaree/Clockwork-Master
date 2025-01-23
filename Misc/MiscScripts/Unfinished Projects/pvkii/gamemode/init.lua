// Include gamemode files
include( "shared.lua" )

// Send gamemode files
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_teams.lua" )
AddCSLuaFile( "vgui/hud.lua" )
AddCSLuaFile( "vgui/healtharmor.lua" )

// To do: Proper team selection and stuff
function GM:PlayerInitialSpawn( ply )
	self:SetClass( ply, self:ClassByName( "Skirmisher" ) )
end

function GM:PlayerLoadout( ply )
	local class = ply.Class
	
	for _, item in ipairs( class.Loadout ) do
		ply:Give( item )
	end
	
	ply:SetWalkSpeed( class.Speed )
	ply:SetRunSpeed( class.Speed )
	
	ply:SetHealth( class.Health )
	ply:SetArmor( class.Armor )
end

function GM:PlayerSelectSpawn( ply )
	local t = ply:Team()
	
	if ( t == TEAM_PIRATES ) then
		return table.Random( ents.FindByClass( "info_player_pirate" ) )
	elseif ( t == TEAM_VIKINGS ) then
		return table.Random( ents.FindByClass( "info_player_viking" ) )
	elseif ( t == TEAM_KNIGHTS ) then
		return table.Random( ents.FindByClass( "info_player_knight" ) )
	end
end

function GM:PlayerShouldTakeDamage( ply, ent )
	if ( ent:IsPlayer() and ply:Team() == ent:Team() ) then
		return false
	else
		return true
	end
end

function GM:KeyPress( ply, key )
	if ( key == IN_USE ) then
		local ent = ply:GetEyeTrace().Entity
		if ( !ply:HasWeapon( "weapon_chest" ) and ent.ChestWep and ent.ChestWep.NextPickup < CurTime() and ent:GetPos():Distance( ply:GetPos() ) < 90 ) then
			ply:StripWeapons()
			
			ply.ChestPickupTimeout = CurTime() + 0.1
			ent.ChestWep:SetSolid( true )
			ent.ChestWep:SetPos( ply:GetPos() )
			ent.ChestWep.NextDrop = CurTime() + 1.5
			ent.ChestWep.Owner = ply
			
			ent:Remove()
		end	
	end
end

function GM:Think()
	// Play a sound when a chest hits something after being dropped
	for _, ent in ipairs( ents.FindByClass( "weapon_chest" ) ) do
		if ( ent.DueHit and ValidEntity( ent.PhysEnt ) ) then
			if ( ent.PhysEnt.LVel and ent.PhysEnt.LVel < 0 and ent.PhysEnt:GetVelocity().z > ent.PhysEnt.LVel and CurTime() - (ent.NextPickup-1.5) > 0.1 ) then
				ent.PhysEnt:EmitSound( "physics/chest_drop.wav", 100, 100 )
				ent.DueHit = false
			else
				ent.PhysEnt.LVel = ent.PhysEnt:GetVelocity().z
			end
		end
	end
end

function GM:PlayerSwitchFlashlight( ply, state )
	return false
end

function GM:DoPlayerDeath( ply, att, dmg )
	local wep = ply:GetWeapon( "weapon_chest" )
	if ( ValidEntity( wep ) ) then
		ply:DropWeapon( wep )
	end
	
	self.BaseClass:DoPlayerDeath( ply, att, dmg )
end