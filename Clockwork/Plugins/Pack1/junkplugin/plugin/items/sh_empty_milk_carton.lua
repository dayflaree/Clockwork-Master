local ITEM = Clockwork.item:New();
ITEM.name = "Empty Milk Carton";
ITEM.uniqueID = "empty_milk_carton";
ITEM.spawnValue = 30;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl";
ITEM.weight = 0.5;
ITEM.access = "jM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty carton of milk.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();