require("datastream")

AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')
include('sv_player_extension.lua')

function GM:Initialize()
	
end

function GM:PlayerInitialSpawn(ply)
	ply:SetPos(Vector(0, 0, 500))
end

function GM:PlayerSpawn(ply)
	ply:Freeze()
	ply:Lock()
	ply:CrosshairDisable()
	ply:StripWeapons()
end

function GM:PlayerLoadout(ply)
	
end

function GM:Think()
	
end

concommand.Add("placement", function(ply, cmd, args)
	
end)