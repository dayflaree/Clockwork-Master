--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("custom_clothes");
ITEM.cost = 0;
ITEM.access = "OL";
ITEM.name = "Medic Uniform";
ITEM.group = "group03m";
ITEM.weight = 1;
ITEM.business = true;
ITEM.batch = 1;
ITEM.armorScale = 0.1;
ITEM.description = "A medic uniform with a yellow insignia.";

Clockwork.item:Register(ITEM);