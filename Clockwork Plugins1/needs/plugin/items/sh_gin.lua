local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Gin";
ITEM.uniqueID = "gin";
ITEM.spawnValue = 10;
ITEM.cost = 18;
ITEM.health = 3;
ITEM.thirst = 30;
ITEM.junk = "empty_bottle";
ITEM.drunkTime = 360;
ITEM.model = "models/bioshockinfinite/gin_bottle.mdl";
ITEM.weight = 0.7;
ITEM.access = "Mv";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = true;
ITEM.description = "A very strong bottle of alcohol in a dark bottle. It's branded with a label, reading 'Gustaf's Sloe Gin'. It appears to be 45% ABV, and smells distinctly of Juniper Berries.";
ITEM.spawnValue = 2;
ITEM.spawnType = "consumable";

ITEM:Register();