if SERVER then
	AddCSLuaFile("autorun/awesomeadmin.lua")
	
	AddCSLuaFile("sh_awesomeadmin.lua")
	AddCSLuaFile("cl_awesomeadmin.lua")
	AddCSLuaFile("cl_player_extension.lua")
	
	include("sh_awesomeadmin.lua")
	include("sv_awesomeadmin.lua")
	include("sv_player_extension.lua")
end

if CLIENT then
	include("sh_awesomeadmin.lua")
	include("cl_awesomeadmin.lua")
	include("cl_player_extension.lua")
end