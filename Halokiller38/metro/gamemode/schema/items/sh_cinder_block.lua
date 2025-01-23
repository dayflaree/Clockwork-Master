--[[
Name: "sh_cinder_block.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "junk_base";
ITEM.name = "Cinder Block";
ITEM.worth = 1;
ITEM.model = "models/props_junk/cinderblock01a.mdl";
ITEM.weight = 2;
ITEM.description = "A heavy block of concrete.";
ITEM.access = "y";
ITEM.business = true;
ITEM.cost = 1;

openAura.item:Register(ITEM);