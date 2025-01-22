local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Milk Carton";
ITEM.uniqueID = "milk_carton";
ITEM.spawnValue = 24;
ITEM.spawnType = "consumable";
ITEM.cost = 10;
ITEM.health = 4;
ITEM.thirst = 20;
ITEM.hunger = 15;
ITEM.junk = "empty_milk_carton";
ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl";
ITEM.weight = 1.2;
ITEM.access = "Mv";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = true;
ITEM.description = "A small cardboard carton filled with cow's milk. We're not entirely sure how it's still possible to farm dairy cows, so our hats go off to the folks at The Armory for this one.";

ITEM:Register();