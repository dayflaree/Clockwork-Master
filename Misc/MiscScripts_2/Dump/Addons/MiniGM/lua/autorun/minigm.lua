if SERVER then
	AddCSLuaFile("autorun/minigm.lua")
	AddCSLuaFile("sh_minigm.lua")
	AddCSLuaFile("sv_minigm.lua")
	
	include("sh_minigm.lua")
	include("sv_minigm.lua")
end

if CLIENT then
	include("sh_minigm.lua")
	include("cl_minigm.lua")
end