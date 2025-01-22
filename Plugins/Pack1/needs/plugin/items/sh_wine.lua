local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Bottle of Wine";
ITEM.uniqueID = "wine";
ITEM.cost = 24;
ITEM.thirst = 35;
ITEM.health = 4;
ITEM.junk = "empty_bottle";
ITEM.drunkTime = 360;
ITEM.model = "models/bioshockinfinite/winebottle.mdl";
ITEM.weight = 1.2;
ITEM.access = "Mv";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = true;
ITEM.description = "A bottle of wine. It's clearly from pre-unification, but has aged rather well. Dusting off the label, you can read 'Roman Vineyards', upon it. It's around 11% ABV.";

ITEM:Register();