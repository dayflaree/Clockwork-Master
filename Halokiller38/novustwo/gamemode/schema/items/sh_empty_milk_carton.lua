--[[
Name: "sh_empty_milk_carton.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Empty Milk Carton";
ITEM.worth = 1;
ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl";
ITEM.weight = 0.1;
ITEM.description = "An empty milk carton, it smells like shit.";

nexus.item.Register(ITEM);