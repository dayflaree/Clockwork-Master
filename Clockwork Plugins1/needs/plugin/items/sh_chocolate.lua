local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Chocolate";
ITEM.uniqueID = "chocolate";
ITEM.model = "models/bioshockinfinite/loot_candy_chocolate.mdl";
ITEM.description = "A small bar of 'Cara's Chocolate'. It appears to be the kind you could buy cheaply in a supermarket, but hey, at least it's gluten free.";
ITEM.weight = 0.2;
ITEM.hunger = 20;
ITEM.health = 4;
ITEM.cost = 8;
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnValue = 34;
ITEM.spawnType = "consumable";

ITEM:Register();