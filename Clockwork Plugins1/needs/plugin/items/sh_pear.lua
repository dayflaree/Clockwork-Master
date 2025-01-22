local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Pear";
ITEM.uniqueID = "pear";
ITEM.spawnValue = 16;
ITEM.spawnType = "consumable";
ITEM.cost = 10;
ITEM.hunger = 20;
ITEM.thirst = 10;
ITEM.health = 3;
ITEM.model = "models/bioshockinfinite/loot_pear.mdl";
ITEM.weight = 0.2;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "A delicious, fresh green pear grown by the powers that be in the outlands. It tastes juicy and light.";

ITEM:Register();