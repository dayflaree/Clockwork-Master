--[[
Name: "sh_bleach.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "junk_base";
ITEM.name = "Bleach";
ITEM.model = "models/props_junk/garbage_plasticbottle001a.mdl";
ITEM.plural = "Bleaches";
ITEM.worth = 1;
ITEM.weight = 0.1;
ITEM.description = "A bottle of bleach, this is dangerous stuff.";
ITEM.cost = 2;
ITEM.access = "M";
ITEM.business = true;

openAura.item:Register(ITEM);