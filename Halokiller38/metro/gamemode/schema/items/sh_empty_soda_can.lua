--[[
Name: "sh_empty_soda_can.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "junk_base";
ITEM.name = "Empty Soda Can";
ITEM.worth = 1;
ITEM.model = "models/props_junk/popcan01a.mdl";
ITEM.weight = 0.1
ITEM.access = "y";
ITEM.business = true;
ITEM.description = "An empty soda can.";
ITEM.cost = 1;

openAura.item:Register(ITEM);