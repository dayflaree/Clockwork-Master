local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Dirty Water";
ITEM.uniqueID = "water_dirty";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 65;
ITEM.model = "models/warz/consumables/gatorade.mdl";
ITEM.weight = 0.5;
ITEM.thirst = 5;
ITEM.damage = 10;
ITEM.junk = "empty_bottle";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = false;
ITEM.description = "A bottle filled with contaminated water, yellow with filth. Probably a good idea to find a water filter, unless you're really desparate.";

ITEM:Register();