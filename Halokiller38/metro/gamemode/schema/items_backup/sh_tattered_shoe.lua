--[[
Name: "sh_tattered_shoe.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "junk_base";
ITEM.name = "Tattered Shoe";
ITEM.worth = 1;
ITEM.model = "models/props_junk/shoe001a.mdl";
ITEM.weight = 0.1
ITEM.description = "A smelly old shoe.";
ITEM.access = "y";
ITEM.business = true;
ITEM.cost = 1;

openAura.item:Register(ITEM);