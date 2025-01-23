ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "Pulse-Rifle Energy";
	ITEM.cost = 0;
	ITEM.factions = {FACTION_OTA}
	ITEM.model = "models/items/combine_rifle_cartridge01.mdl";
	ITEM.plural = "Pulse-Rifle Energy";
	ITEM.weight = 1;
	ITEM.uniqueID = "ammo_ar2";
	ITEM.business = true;
	ITEM.ammoClass = "ar2";
	ITEM.ammoAmount = 30;
	ITEM.description = "A cartridge with a blue glow emitting from it.";
Clockwork.item:Register(ITEM);