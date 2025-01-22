local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Whiskey";
ITEM.uniqueID = "whiskey";
ITEM.spawnValue = 8;
ITEM.spawnType = "consumable";
ITEM.cost = 18;
ITEM.model = "models/props_junk/garbage_glassbottle002a.mdl";
ITEM.weight = 1.2;
ITEM.thirst = 35;
ITEM.health = 3;
ITEM.junk = "empty_bottle";
ITEM.drunkTime = 360;
ITEM.access = "Mv";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = true;
ITEM.description = "A 70CL bottle of sour mash Whiskey. It is American produced, and named with a typical odd alcohol brand: 'Rabid Maggot'. It is around 40% ABV";

ITEM:Register();