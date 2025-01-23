--[[
Name: "sh_empty_beer_bottle.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Used Buffout";
ITEM.worth = 5;
ITEM.model = "models/fallout/items/chems/buffout.mdl";
ITEM.weight = 0.1
ITEM.description = "An empty bottle of Buffout, who used so much buffout?";

blueprint.item.Register(ITEM);