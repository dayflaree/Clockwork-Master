--[[
Name: "sh_empty_water_bottle.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "junk_base";
ITEM.name = "Broken AK74";
ITEM.worth = 2;
ITEM.model = "models/maver1k_XVII/metro_ak_broken.mdl";
ITEM.weight = 0.1
ITEM.description = "A broken AK74, the barrel is bent and the stock has snapped off.";
ITEM.access = "y";
ITEM.business = true;
ITEM.cost = 1;

openAura.item:Register(ITEM);