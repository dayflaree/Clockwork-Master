
local ITEM = Clockwork.item:New("backpack_base");
ITEM.name = "Pouch";
ITEM.uniqueID = "pouch";
ITEM.access = "Mv";
ITEM.spawnType = "misc";
ITEM.spawnValue = 12;
ITEM.cost = 10;
ITEM.business = true;
ITEM.model = "models/props_junk/garbage_bag001a.mdl";
ITEM.actualWeight = 0.4;
ITEM.invSpace = 1;
ITEM.slot = "pouch";
ITEM.slotSpace = 5;
ITEM.description = "A small pouch ideal for holding small things.";

ITEM:Register();