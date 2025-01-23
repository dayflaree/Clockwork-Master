--[[
	Name: sh_info.lua.
	Author: LauScript.
--]]

local PLUGIN = PLUGIN;

openAura:IncludePrefixed("sh_auto.lua");

-- A function to load the area names.
function PLUGIN:LoadSurfaceZones()
	self.surfaceZones = openAura:RestoreSchemaData( "plugins/surfacezones/"..game.GetMap() );
end;

-- A function to save the area names.
function PLUGIN:SaveSurfaceZones()
	openAura:SaveSchemaData("plugins/surfacezones/"..game.GetMap(), self.surfaceZones);
end;