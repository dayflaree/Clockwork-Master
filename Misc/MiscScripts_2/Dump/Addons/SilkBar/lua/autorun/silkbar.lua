if SERVER then
	AddCSLuaFile("sh_silkbar.lua")
	AddCSLuaFile("cl_silkbar.lua")
	include("sv_silkbar.lua")
else
	include("cl_silkbar.lua")
end

include("sh_silkbar.lua")