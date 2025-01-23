--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("ammo_base");
	ITEM.uniqueID = "ammo_pistol";
	ITEM.name = "9x19mm Rounds";
	ITEM.cost = 25;
	ITEM.model = "models/items/boxsrounds.mdl";
	ITEM.weight = 1;
	ITEM.business = true;
	ITEM.batch = 3;
	ITEM.access = "v";
	ITEM.ammoClass = "pistol";
	ITEM.ammoAmount = 20;
	ITEM.description = "An average sized green container with 9mm on the side.";
Clockwork.item:Register(ITEM);