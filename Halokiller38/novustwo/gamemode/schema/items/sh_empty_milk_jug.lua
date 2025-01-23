--[[
Name: "sh_empty_milk_jug.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Empty Milk Jug";
ITEM.worth = 1;
ITEM.model = "models/props_junk/garbage_milkcarton001a.mdl";
ITEM.weight = 0.1;
ITEM.description = "An empty milk jug, it smells like shit.";

nexus.item.Register(ITEM);