local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Chips";
ITEM.uniqueID = "chips";
ITEM.model = "models/bioshockinfinite/bag_of_chips.mdl";
ITEM.description = "A packet of plain potato chips. They're salty and oily, and let's be honest, once you open the bag, it was about sixty percent air anyway.";
ITEM.weight = 0.2;
ITEM.hunger = 15;
ITEM.health = 1;
ITEM.cost = 7;
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnValue = 20;
ITEM.spawnType = "consumable";

ITEM:Register();