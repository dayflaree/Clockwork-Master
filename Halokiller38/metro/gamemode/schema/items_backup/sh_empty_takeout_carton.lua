--[[
Name: "sh_empty_takeout_carton.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "junk_base";
ITEM.name = "Empty Takeout Carton";
ITEM.worth = 1;
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.weight = 0.1
ITEM.access = "y";
ITEM.business = true;
ITEM.description = "An old and empty takeout carton.";
ITEM.cost = 1;

openAura.item:Register(ITEM);