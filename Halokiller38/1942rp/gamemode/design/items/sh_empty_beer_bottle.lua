--[[
Name: "sh_empty_beer_bottle.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Empty Beer Bottle";
ITEM.worth = 1;
ITEM.model = "models/fallout/items/beerbottle.mdl";
ITEM.weight = 0.1
ITEM.description = "An empty bottle made of glass, it smells like beer.";

blueprint.item.Register(ITEM);