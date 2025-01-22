local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Green Apple";
ITEM.uniqueID = "apple";
ITEM.description = "A sweet green apple, freshly grown by the powers that be in the outlands. It is juicy, hydrating, and arguably tastier than its red counterpart.";
ITEM.model = "models/pg_props/pg_food/pg_apple.mdl";
ITEM.weight = 0.2;
ITEM.hunger = 40;
ITEM.thirst = 20;
ITEM.health = 10;
ITEM.skin = 1;
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 5;

ITEM:Register();