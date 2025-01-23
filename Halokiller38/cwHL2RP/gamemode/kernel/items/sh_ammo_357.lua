--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = ".357 Rounds";
	ITEM.cost = 50;
	ITEM.model = "models/items/357ammo.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "ammo_357";
	ITEM.business = true;
	ITEM.batch = 3;
	ITEM.access = "v";
	ITEM.ammoClass = "357";
	ITEM.ammoAmount = 15;
	ITEM.description = "An orange container with Magnum on the side.";
Clockwork.item:Register(ITEM);