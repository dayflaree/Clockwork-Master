local ITEM = Clockwork.item:New();
ITEM.name = "Empty Soda Bottle";
ITEM.uniqueID = "empty_soda";
ITEM.spawnValue = 19;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/props_junk/garbage_plasticbottle003a.mdl";
ITEM.weight = 0.4;
ITEM.access = "jM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty bottle of soda.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();