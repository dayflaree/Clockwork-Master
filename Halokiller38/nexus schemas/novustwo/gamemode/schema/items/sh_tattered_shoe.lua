--[[
Name: "sh_tattered_shoe.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Tattered Shoe";
ITEM.worth = 1;
ITEM.model = "models/props_junk/shoe001a.mdl";
ITEM.weight = 0.1
ITEM.description = "A smelly old shoe.";

nexus.item.Register(ITEM);