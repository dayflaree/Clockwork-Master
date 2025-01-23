--[[
Name: "sh_empty_beer_bottle.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "junk_base";
ITEM.name = "Empty Beer Bottle";
ITEM.worth = 1;
ITEM.model = "models/props_junk/garbage_glassbottle001a.mdl";
ITEM.weight = 0.1
ITEM.access = "y";
ITEM.business = true;
ITEM.description = "An empty bottle made of glass, it smells like beer.";
ITEM.cost = 1;

openAura.item:Register(ITEM);