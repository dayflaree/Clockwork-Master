--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "Energy";
	ITEM.cost = 0;
	ITEM.factions = {FACTION_OTA}
	ITEM.model = "models/items/combine_rifle_ammo01.mdl";
	ITEM.weight = 1;
	ITEM.business = true;
	ITEM.batch = 3;
	ITEM.access = "v";
	ITEM.ammoClass = "ar2altfire";
	ITEM.ammoAmount = 15;
	ITEM.description = "A small capsule that is used to charge weapons that use laser technology.";
Clockwork.item:Register(ITEM);