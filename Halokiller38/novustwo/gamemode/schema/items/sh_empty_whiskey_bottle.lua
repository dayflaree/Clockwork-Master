--[[
Name: "sh_empty_whiskey_bottle.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Empty Whiskey Bottle";
ITEM.worth = 1;
ITEM.model = "models/props_junk/garbage_glassbottle002a.mdl";
ITEM.weight = 0.1
ITEM.description = "An empty glass bottle, a brown bag is wrapped around it.";

nexus.item.Register(ITEM);