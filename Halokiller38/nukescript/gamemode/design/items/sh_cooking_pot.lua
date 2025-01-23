--[[
Name: "sh_cooking_pot.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Cooking Pot";
ITEM.worth = 2;
ITEM.model = "models/props_interiors/pot02a.mdl";
ITEM.weight = 0.2
ITEM.description = "A dirty pot used for cooking.";

blueprint.item.Register(ITEM);