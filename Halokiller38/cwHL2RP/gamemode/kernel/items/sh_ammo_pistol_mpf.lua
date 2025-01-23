--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "MPF Issued 9x19mm Rounds";
	ITEM.cost = 10;
	ITEM.model = "models/items/boxsrounds.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "ammo_pistol_mpf";
	ITEM.factions = {FACTION_MPF};
	ITEM.business = true;
	ITEM.batch = 3;
	ITEM.ammoClass = "pistol";
	ITEM.ammoAmount = 20;
	ITEM.description = "An average sized green container with 9mm on the side.";
Clockwork.item:Register(ITEM);