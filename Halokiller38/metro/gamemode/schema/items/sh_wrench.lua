--[[
Name: "sh_wrench.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "junk_base";
ITEM.name = "Wrench";
ITEM.worth = 2;
ITEM.model = "models/props_c17/tools_wrench01a.mdl";
ITEM.weight = 0.2
ITEM.description = "A rusty wrench.";
ITEM.access = "y";
ITEM.business = true;
ITEM.cost = 1;

openAura.item:Register(ITEM);