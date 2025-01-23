--[[
Name: "sh_empty_beer_bottle.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Used Med-X";
ITEM.worth = 5;
ITEM.model = "models/fallout/items/chems/medx.mdl";
ITEM.weight = 0.1
ITEM.description = "A used Med-X syringe, could be worth something to someone.";

blueprint.item.Register(ITEM);