local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Milk Jug";
ITEM.uniqueID = "milk_jug";
ITEM.spawnValue = 16;
ITEM.spawnType = "consumable";
ITEM.cost = 18;
ITEM.health = 4;
ITEM.thirst = 30;
ITEM.hunger = 20;
ITEM.junk = "empty_milk_jug";
ITEM.model = "models/props_junk/garbage_milkcarton001a.mdl";
ITEM.weight = 1.2;
ITEM.access = "Mv";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = true;
ITEM.description = "A large plastic gallon jug, filled with cow's milk. We're not entirely sure how it's still possible to farm dairy cows, so our hats go off to the folks at The Armory for this one.";

ITEM:Register();