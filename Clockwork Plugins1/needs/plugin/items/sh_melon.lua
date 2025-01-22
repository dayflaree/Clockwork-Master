local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Melon";
ITEM.uniqueID = "melon";
ITEM.spawnValue = 7;
ITEM.spawnType = "consumable";
ITEM.cost = 25;
ITEM.health = 6;
ITEM.hunger = 40;
ITEM.thirst = 15;
ITEM.model = "models/props_junk/watermelon01.mdl";
ITEM.weight = 2;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "A large, fresh watermelon grown by the powers that be in the outlands. Cutting into it causes juice to trickle down its skin. It tastes juicy and delicious.";

ITEM:Register();