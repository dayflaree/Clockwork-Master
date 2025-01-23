--[[
Name: "sh_cooking_pot.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "junk_base";
ITEM.name = "Cooking Pot";
ITEM.worth = 2;
ITEM.model = "models/props_interiors/pot02a.mdl";
ITEM.weight = 0.2
ITEM.access = "y";
ITEM.business = true;
ITEM.description = "A dirty pot used for cooking.";
ITEM.cost = 1;

openAura.item:Register(ITEM);