--[[
Name: "sh_auto.lua".
Product: "Day One".
--]]

local PLUGIN = PLUGIN;

blueprint.player.RegisterSharedVar("sh_Stamina", NWTYPE_NUMBER, true);

BLUEPRINT:IncludePrefixed("sv_hooks.lua");