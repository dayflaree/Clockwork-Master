--[[
Name: "sh_auto.lua".
Product: "eXperim3nt".
--]]

local MOUNT = MOUNT;

nexus.player.RegisterSharedVar("sh_Radiation", NWTYPE_NUMBER, true);

NEXUS:IncludePrefixed("sv_hooks.lua");
NEXUS:IncludePrefixed("cl_hooks.lua");