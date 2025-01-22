local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Lager";
ITEM.uniqueID = "uu_lager";
ITEM.spawnValue = 10;
ITEM.spawnType = "consumable";
ITEM.cost = 15;
ITEM.health = 5;
ITEM.thirst = 25;
ITEM.junk = "empty_can";
ITEM.drunkTime = 60;
ITEM.model = "models/mechanics/various/211.mdl";
ITEM.weight = 0.7;
ITEM.access = "U";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = true;
ITEM.category = "UU-Branded Items";
ITEM.description = "A brushed aluminum can of golden liquid, adorning the UU Brand. It seems to be carbonated or oxygenated, creating the illusion of being real alcohol, but is only around 0.5% ABV, so it'd take a lot to get you drunk.";

ITEM:Register();