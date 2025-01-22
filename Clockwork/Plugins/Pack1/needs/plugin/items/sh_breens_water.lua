
local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Breen's Water";
ITEM.uniqueID = "breens_water";
ITEM.model = "models/props_lunk/popcan01a.mdl";
ITEM.category = "UU-Branded Items";
ITEM.weight = 0.5;
ITEM.thirst = 10;
ITEM.health = 2;
ITEM.junk = "empty_can"
ITEM.business = true;
ITEM.access = "1";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.description = "A blue aluminum can, filled with water. It tastes distinctly metallic.";
ITEM.spawnValue = 40;
ITEM.spawnType = "consumable";

ITEM:Register();