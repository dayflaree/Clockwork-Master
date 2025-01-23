if SERVER then
	AddCSLuaFile("autorun/lolbot.lua")
	AddCSLuaFile("cl_lolbot.lua")
	
	include("sv_lolbot.lua")
	for k, filename in pairs(file.FindInLua("commands/lol_*.lua")) do
		include("commands/"..filename)
	end
end

if CLIENT then
	include("cl_lolbot.lua")
end