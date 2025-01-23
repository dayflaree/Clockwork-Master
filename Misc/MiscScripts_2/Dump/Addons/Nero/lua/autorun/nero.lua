AddCSLuaFile("autorun/nero.lua")

IncludeClientFile("cl_nero_player_extension.lua")

IncludeClientFile("sh_nero.lua")
IncludeClientFile("cl_nero.lua")

if SERVER then
	include("sv_nero_player_extension.lua")
	include("sv_nero_entity_extension.lua")
	
	include("sh_nero.lua")
	include("sv_nero.lua")
end

for _, filename in pairs(file.FindInLua("nero_plugins/*.lua")) do
	AddCSLuaFile("nero_plugins/" .. filename)
	include("nero_plugins/" .. filename)
end
	
	--[[ 
	if PLUGIN.Dependencies then
		for _, dep in pairs(PLUGIN.Dependencies) do
			AddCSLuaFile("nero_plugins/" .. dep .. ".lua")
	
			PLUGIN = {}
			include("nero_plugins/" .. dep .. ".lua")
			
			NERO:RegisterPlugin(PLUGIN)
		end
	end
end ]]