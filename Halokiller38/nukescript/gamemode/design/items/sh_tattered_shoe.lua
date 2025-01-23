--[[
Name: "sh_tattered_shoe.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Tattered Shoe";
ITEM.worth = 1;
ITEM.model = "models/props_junk/shoe001a.mdl";
ITEM.weight = 0.1
ITEM.description = "A smelly old shoe.";

blueprint.item.Register(ITEM);