local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Fresh Orange";
ITEM.uniqueID = "orange";
ITEM.spawnValue = 5;
ITEM.spawnType = "consumable";
ITEM.cost = 12;
ITEM.health = 4;
ITEM.hunger = 20;
ITEM.thirst = 10;
ITEM.model = "models/props/cs_italy/orange.mdl";
ITEM.weight = 0.25;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "A freshly grown orange, ready to be open and split into segments; grown by the powers that be in the outlands.";

ITEM:Register(ITEM);