local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Sandwich";
ITEM.uniqueID = "uu_sandwich";
ITEM.description = "A rather dry-looking sandwich, with a Union logo on its packaging.";
ITEM.model = "models/pg_props/pg_food/pg_sandwich.mdl";
ITEM.weight = 0.2;
ITEM.hunger = 50;
ITEM.health = 10;
ITEM.cost = 12;
ITEM.business = true;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.spawnValue = 24;
ITEM.spawnType = "consumable";

ITEM:Register();