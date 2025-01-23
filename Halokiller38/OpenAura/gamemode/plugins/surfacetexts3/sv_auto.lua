--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

openAura:IncludePrefixed("sh_auto.lua");

-- A function to load the surface texts.
function PLUGIN:LoadSurfaceTexts()
	self.surfaceTexts = openAura:RestoreSchemaData( "plugins/texts4/"..game.GetMap() );
end;

-- A function to save the surface texts.
function PLUGIN:SaveSurfaceTexts()
	openAura:SaveSchemaData("plugins/texts4/"..game.GetMap(), self.surfaceTexts);
end;