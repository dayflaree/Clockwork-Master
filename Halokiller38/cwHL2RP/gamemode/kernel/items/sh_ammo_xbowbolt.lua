--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "5.7x28mm Rounds";
	ITEM.cost = 75;
	ITEM.model = "models/items/ammorounds.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "ammo_xbowbolt";
	ITEM.business = true;
	ITEM.batch = 3;
	ITEM.access = "v";
	ITEM.ammoClass = "xbowbolt";
	ITEM.ammoAmount = 15;
	ITEM.description = "An average sized blue container with 5.7x28mm on the side.";
Clockwork.item:Register(ITEM);