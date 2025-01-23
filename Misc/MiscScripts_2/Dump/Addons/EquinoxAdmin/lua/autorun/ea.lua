require("glon")

EA = {}
EA.__index = EA

if SERVER then
	AddCSLuaFile("autorun/ea.lua")
	AddCSLuaFile("sh_ea.lua")
	AddCSLuaFile("cl_player_extension.lua")
	AddCSLuaFile("cl_ea.lua")
	
	include("sv_player_extension.lua")
	include("sh_ea.lua")
	include("sv_ea.lua")
	
	for _, filename in pairs(file.FindInLua("ea_plugins/*.lua")) do
		local pre = string.Left(filename, string.find(filename, "_") - 1)
		if pre == "cl" or pre == "sh" then
			AddCSLuaFile("ea_plugins/"..filename)
		elseif pre == "sv" then
			include("ea_plugins/"..filename)
		end
	end
end

if CLIENT then
	include("sh_ea.lua")
	include("cl_player_extension.lua")
	include("cl_ea.lua")
	
	for _, filename in pairs(file.FindInLua("ea_plugins/*.lua")) do
		local pre = string.Left(filename, string.find(filename, "_") - 1)
		if pre == "cl" or pre == "sh" then
			include("ea_plugins/"..filename)
		end
	end
end