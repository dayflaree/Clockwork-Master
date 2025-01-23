--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "MPF Issued 5.56x45mm Rounds";
	ITEM.cost = 20;
	ITEM.model = "models/items/boxmrounds.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "ammo_smg1_mpf";
	ITEM.factions = {FACTION_MPF};
	ITEM.business = true;
	ITEM.batch = 3;
	ITEM.ammoClass = "smg1";
	ITEM.ammoAmount = 25;
	ITEM.description = "A large green container with 5.56x45mm on the side.";
Clockwork.item:Register(ITEM);