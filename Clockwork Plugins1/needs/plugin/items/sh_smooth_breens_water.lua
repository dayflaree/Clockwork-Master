local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Smooth Breen's Water";
ITEM.uniqueID = "smooth_breens_water";
ITEM.cost = 10;
ITEM.spawnValue = 19;
ITEM.spawnType = "consumable";
ITEM.skin = 1;
ITEM.model = "models/props_lunk/popcan01a.mdl";
ITEM.weight = 0.5;
ITEM.health = 3;
ITEM.thirst = 15;
ITEM.junk = "empty_can";
ITEM.access = "1";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = false;
ITEM.category = "UU-Branded Items";
ITEM.description = "A red aluminum can, filled with water. The steely taste from its blue counterpart seems to be absent, however.";

ITEM:Register();