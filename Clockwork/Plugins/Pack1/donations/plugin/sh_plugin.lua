
--[[
	This should really be modular and allow for almost 
	any customization without editing the plugin code.
--]]

local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sh_hooks.lua");

PLUGIN.limitToolgun = {
	["operator"] = {
		["nocollide"] = true,
		["remover"] = true
	}	
};