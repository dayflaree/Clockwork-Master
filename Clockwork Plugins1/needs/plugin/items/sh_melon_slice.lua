local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Melon Slice";
ITEM.uniqueID = "melon_slice";
ITEM.cost = 5;
ITEM.health = 2;
ITEM.hunger = 8;
ITEM.thirst = 2;
ITEM.spawnValue = 9;
ITEM.spawnType = "consumable";
ITEM.model = "models/props_junk/watermelon01_chunk01b.mdl";
ITEM.weight = 0.25;
ITEM.access = "Mv";
ITEM.business = false;
ITEM.description = "A slice of fresh watermelon grown by the powers that be in the outlands. Juice seems to trickle down the exterior of its skin. It tastes juicy and delicious.";

ITEM:Register();