--[[
Name: "sh_vegetable_oil.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "junk_base";
ITEM.name = "Vegetable Oil";
ITEM.model = "models/props_junk/garbage_plasticbottle002a.mdl";
ITEM.worth = 1;
ITEM.cost = 3;
ITEM.access = "M";
ITEM.business = true;
ITEM.weight = 0.1;
ITEM.description = "A bottle of vegetable oil, it isn't very tasty.";

openAura.item:Register(ITEM);