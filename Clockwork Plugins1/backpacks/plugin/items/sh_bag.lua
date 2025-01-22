
local ITEM = Clockwork.item:New("backpack_base");
ITEM.name = "Bag";
ITEM.uniqueID = "bag";
ITEM.spawnValue = 9;
ITEM.spawnType = "misc";
ITEM.business = true;
ITEM.access = "Mv";
ITEM.cost = 15;
ITEM.model = "models/props_junk/garbage_bag001a.mdl";
ITEM.actualWeight = 1;
ITEM.invSpace = 2;
ITEM.slot = "back";
ITEM.slotSpace = 3;
ITEM.description = "A cloth bag with some cables. It's better than nothing...";

ITEM:Register();