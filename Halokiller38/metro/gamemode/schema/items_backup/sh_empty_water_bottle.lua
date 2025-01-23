--[[
Name: "sh_empty_water_bottle.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "junk_base";
ITEM.name = "Empty Water Bottle";
ITEM.worth = 1;
ITEM.model = "models/props_junk/glassbottle01a.mdl";
ITEM.weight = 0.1
ITEM.description = "An empty bottle made of glass, it has no scent.";
ITEM.access = "y";
ITEM.business = true;
ITEM.cost = 1;

openAura.item:Register(ITEM);