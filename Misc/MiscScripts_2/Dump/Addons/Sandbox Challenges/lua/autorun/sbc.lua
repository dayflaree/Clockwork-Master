if SERVER then
	
	AddCSLuaFile("sh_sbc.lua")
	AddCSLuaFile("sv_sbc.lua")
	
	include("sh_sbc.lua")
	include("sv_sbc.lua")
	
end

if CLIENT then
	
	include("sh_sbc.lua")
	include("cl_sbc.lua")
	
end

for _, filename in pairs(file.FindInLua("challenges/*.lua")) do
	AddCSLuaFile("challenges/" .. filename)
	include("challenges/" .. filename)
end