local ITEM = Clockwork.item:New();
ITEM.name = "Empty Breen's Water Can";
ITEM.uniqueID = "empty_can";
ITEM.spawnValue = 30;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/props_nunk/popcan01a.mdl";
ITEM.weight = 0.2;
ITEM.access = "jM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty can of Breen's water.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();