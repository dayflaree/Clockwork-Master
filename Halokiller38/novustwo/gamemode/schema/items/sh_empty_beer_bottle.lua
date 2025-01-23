--[[
Name: "sh_empty_beer_bottle.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Empty Beer Bottle";
ITEM.worth = 1;
ITEM.model = "models/props_junk/garbage_glassbottle001a.mdl";
ITEM.weight = 0.1
ITEM.description = "An empty bottle made of glass, it smells like beer.";

nexus.item.Register(ITEM);