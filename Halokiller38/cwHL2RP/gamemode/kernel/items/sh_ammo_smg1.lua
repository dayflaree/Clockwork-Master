--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "5.56x45mm Rounds";
	ITEM.cost = 50;
	ITEM.model = "models/items/boxmrounds.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "ammo_smg1";
	ITEM.business = true;
	ITEM.batch = 3;
	ITEM.access = "v";
	ITEM.ammoClass = "smg1";
	ITEM.ammoAmount = 20;
	ITEM.description = "A large green container with 5.56x45mm on the side.";
Clockwork.item:Register(ITEM);