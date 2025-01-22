
local ITEM = Clockwork.item:New("backpack_base");
ITEM.name = "Backpack";
ITEM.uniqueID = "backpack";
ITEM.spawnValue = 5;
ITEM.spawnType = "misc";
ITEM.model = "models/props_junk/garbage_bag001a.mdl";
ITEM.business = true;
ITEM.cost = 25;
ITEM.access = "Mv";
ITEM.actualWeight = 3;
ITEM.invSpace = 6;
ITEM.slot = "back";
ITEM.slotSpace = 6;
ITEM.description = "An old backpack in a good enough state to hold some stuff.";

ITEM:Register();