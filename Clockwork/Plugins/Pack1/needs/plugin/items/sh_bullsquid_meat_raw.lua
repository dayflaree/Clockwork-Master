local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Raw Bullsquid Meat";
ITEM.uniqueID = "bullsquid_meat_raw";
ITEM.spawnValue = 3;
ITEM.spawnType = "consumable";
ITEM.cost = 25;
ITEM.model = "models/gibs/xenians/mgib_06.mdl";
ITEM.weight = 0.2;
ITEM.hunger = 15;
ITEM.damage = 25;
ITEM.access = "Mv";
ITEM.business = false;
ITEM.description = "A stringy cut of tender meat, from the leg of a bullsquid. It's highly toxic raw, and should be thoroughly cooked before consumption.";

ITEM:Register();