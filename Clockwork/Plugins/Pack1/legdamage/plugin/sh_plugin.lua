--[[
	  ___   _     ___ _   _   _  ___ ___ _  _ ___ 
	 / _ \ /_\   | _ \ | | | | |/ __|_ _| \| / __|
	| (_) / _ \  |  _/ |_| |_| | (_ || || .` \__ \
	 \___/_/ \_\ |_| |____\___/ \___|___|_|\_|___/
	LEG DAMAGE                                              
--]]

local openAura = openAura;
local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua")
Clockwork.kernel:IncludePrefixed("sv_plugin.lua")
Clockwork.kernel:IncludePrefixed("sv_hooks.lua")

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Bool("FallenOver");
end;