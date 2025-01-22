local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Special Breen's Water";
ITEM.uniqueID = "special_breens_water";
ITEM.cost = 45;
ITEM.spawnValue = 10;
ITEM.spawnType = "consumable";
ITEM.skin = 2;
ITEM.model = "models/props_lunk/popcan01a.mdl";
ITEM.weight = 0.5;
ITEM.health = 6;
ITEM.thirst = 20;
ITEM.junk = "empty_can";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = false;
ITEM.category = "UU-Branded Items";
ITEM.description = "A yellow aluminium can, containing lemon-flavored water with added caffeine.";

ITEM:Register();