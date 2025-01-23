--[[
Name: "sh_empty_beer_bottle.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Used Psycho";
ITEM.worth = 5;
ITEM.model = "models/clutter/psycho.mdl";
ITEM.weight = 0.1
ITEM.description = "A used drug, could be worth something to raiders.";

blueprint.item.Register(ITEM);