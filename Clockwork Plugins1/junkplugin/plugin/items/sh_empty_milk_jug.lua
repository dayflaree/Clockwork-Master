local ITEM = Clockwork.item:New();
ITEM.name = "Empty Milk Jug";
ITEM.uniqueID = "empty_milk_jug";
ITEM.spawnValue = 30;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/props_junk/garbage_milkcarton001a.mdl";
ITEM.weight = 0.5;
ITEM.access = "jM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty plastic jug.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();