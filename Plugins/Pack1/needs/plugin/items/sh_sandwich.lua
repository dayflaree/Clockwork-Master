local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Greasy Sandwich";
ITEM.uniqueID = "sandwich";
ITEM.description = "A greasy, pre-packaged sandwich with a picture of a slug on the packaging.";
ITEM.model = "models/pg_props/pg_food/pg_sandwich.mdl";
ITEM.weight = 0.2;
ITEM.hunger = 50;
ITEM.health = 10;
ITEM.cost = 12;
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnValue = 24;
ITEM.spawnType = "consumable";

ITEM:Register();