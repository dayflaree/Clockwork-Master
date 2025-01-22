local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Lager";
ITEM.uniqueID = "lager";
ITEM.spawnValue = 15;
ITEM.cost = 12;
ITEM.health = 5;
ITEM.thirst = 25;
ITEM.junk = "empty_can";
ITEM.drunkTime = 60;
ITEM.model = "models/mechanics/various/211.mdl";
ITEM.weight = 0.7;
ITEM.access = "Mv";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = true;
ITEM.description = "A brushed aluminum can of German Lager. The labelling brands this particular product as 'Dallas Sky', and it sits at around 5.2% ABV. It smells hoppy and inviting, like any usual Lager.";
ITEM.spawnValue = 2;
ITEM.spawnType = "consumable";

ITEM:Register();