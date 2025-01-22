local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Granola Bar";
ITEM.uniqueID = "granola_bar";
ITEM.model = "models/warz/consumables/bar_granola.mdl";
ITEM.description = "A small bar of granola, apparently marketed towards hikers due to its name, Roamin' Loaded. Crunchy, no expiration date, and full of calories to keep you going.";
ITEM.weight = 0.05;
ITEM.hunger = 10;
ITEM.health = 5;
ITEM.cost = 8;
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnValue = 50;
ITEM.spawnType = "consumable";

ITEM:Register();