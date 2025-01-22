local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Banana";
ITEM.uniqueID = "banana";
ITEM.description = "A ripe, yet slightly bruised banana, grown freshly by the powers that be in the outlands. It is sweet and mushy.";
ITEM.model = "models/props/cs_italy/bananna.mdl";
ITEM.weight = 0.2;
ITEM.hunger = 25;
ITEM.thirst = 5;
ITEM.health = 4
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnValue = 18;
ITEM.spawnType = "consumable";

ITEM:Register();