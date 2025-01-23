--[[
Name: "sh_empty_water_bottle.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Empty Water Bottle";
ITEM.worth = 1;
ITEM.model = "models/props_junk/glassbottle01a.mdl";
ITEM.weight = 0.1
ITEM.description = "An empty bottle made of glass, it has no scent.";

blueprint.item.Register(ITEM);