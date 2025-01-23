--[[
Name: "sh_empty_beer_bottle.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Used Jet";
ITEM.worth = 3;
ITEM.model = "models/clutter/jet.mdl";
ITEM.weight = 0.1
ITEM.description = "A used jet bottle, could be worth something to raiders.";

blueprint.item.Register(ITEM);