local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Red Apple";
ITEM.uniqueID = "apple_red";
ITEM.description = "A tart red apple, freshly grown by the powers that be in the outlands. It is juicy, with plenty of bite.";
ITEM.model = "models/pg_props/pg_food/pg_apple.mdl";
ITEM.weight = 0.2;
ITEM.hunger = 20;
ITEM.thirst = 10;
ITEM.health = 4;
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 30;

ITEM:Register();