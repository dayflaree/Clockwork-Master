--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("alcohol_base");
ITEM.name = "Whiskey";
ITEM.cost = 50;
ITEM.model = "models/props_junk/garbage_glassbottle002a.mdl";
ITEM.weight = 1.2;
ITEM.business = true;
ITEM.batch = 5;
ITEM.access = "v";
ITEM.attributes = {Stamina = 10};
ITEM.description = "A brown colored whiskey bottle, be careful!";

Clockwork.item:Register(ITEM);