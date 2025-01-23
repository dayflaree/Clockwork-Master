--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "Shotgun Shells";
	ITEM.cost = 100;
	ITEM.model = "models/items/boxbuckshot.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "ammo_buckshot";
	ITEM.business = true;
	ITEM.batch = 3;
	ITEM.access = "v";
	ITEM.ammoClass = "buckshot";
	ITEM.ammoAmount = 8;
	ITEM.description = "A small red box filled with Buckshot on the side.";
Clockwork.item:Register(ITEM);