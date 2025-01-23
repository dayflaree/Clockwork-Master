--[[
Name: "sh_auto.lua".
Product: "Skeleton".
--]]

local PLUGIN = PLUGIN;

resistance.player.RegisterSharedVar("sh_Stamina", NWTYPE_NUMBER, true);

RESISTANCE:IncludePrefixed("sv_hooks.lua");
RESISTANCE:IncludePrefixed("cl_hooks.lua");