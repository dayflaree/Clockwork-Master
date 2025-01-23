--[[
Name: "sh_auto.lua".
Product: "Half-Life 2".
--]]

local PLUGIN = PLUGIN;

MODULE:AddCustomPermit("Literature", "3", "models/props_lab/bindergreenlabel.mdl");

RESISTANCE:IncludePrefixed("cl_hooks.lua");
RESISTANCE:IncludePrefixed("sv_hooks.lua");