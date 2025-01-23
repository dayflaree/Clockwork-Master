--[[
Name: "sh_auto.lua".
Product: "Half-Life 2".
--]]

local PLUGIN = PLUGIN;

resistance.player.RegisterSharedVar("sh_Stamina", NWTYPE_NUMBER, true);

RESISTANCE:IncludePrefixed("sh_coms.lua");
RESISTANCE:IncludePrefixed("sv_hooks.lua");
RESISTANCE:IncludePrefixed("cl_hooks.lua");