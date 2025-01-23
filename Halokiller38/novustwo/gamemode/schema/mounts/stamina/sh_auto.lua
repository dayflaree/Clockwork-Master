--[[
Name: "sh_auto.lua".
Product: "Novus Two".
--]]

local MOUNT = MOUNT;

nexus.player.RegisterSharedVar("sh_Stamina", NWTYPE_NUMBER, true);

NEXUS:IncludePrefixed("sv_hooks.lua");
NEXUS:IncludePrefixed("cl_hooks.lua");