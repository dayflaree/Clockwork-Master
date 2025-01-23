--[[
Name: "sh_tracksuit_clothing.lua".
Product: "Cider Two".
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Tracksuit Clothing";
ITEM.group = "group02";
ITEM.weight = 0.5;
ITEM.batch = 1;
ITEM.cost = 20;
ITEM.access = "U";
ITEM.business = true;
ITEM.description = "Well... the hoodie looks like it's from a tracksuit.";

openAura.item:Register(ITEM);