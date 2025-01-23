--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "7.65x59mm Rounds";
	ITEM.cost = 100;
	ITEM.model = "models/items/ammobox.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "ammo_sniper";
	ITEM.business = true;
	ITEM.batch = 3;
	ITEM.access = "v";
	ITEM.ammoClass = "ar2";
	ITEM.ammoAmount = 6;
	ITEM.description = "A red container with 7.65x59mm on the side.";
Clockwork.item:Register(ITEM);