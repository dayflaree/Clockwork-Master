--[[
Name: "sh_empty_milk_carton.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "junk_base";
ITEM.name = "Empty Milk Carton";
ITEM.worth = 1;
ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl";
ITEM.weight = 0.1;
ITEM.access = "y";
ITEM.business = true;
ITEM.description = "An empty milk carton, it smells like shit.";
ITEM.cost = 1;

openAura.item:Register(ITEM);