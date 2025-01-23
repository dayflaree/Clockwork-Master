if SERVER then
	AddCSLuaFile("autorun/silkchat.lua")
	
	resource.AddFile("materials/gui/silkicons/information.vtf")
	resource.AddFile("materials/gui/silkicons/information.vmt")
	
	resource.AddFile("materials/gui/silkicons/exclamation.vtf")
	resource.AddFile("materials/gui/silkicons/exclamation.vmt")
end

if CLIENT then
	include("cl_silkchat.lua")
end