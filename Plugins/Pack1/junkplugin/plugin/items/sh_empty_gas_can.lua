local ITEM = Clockwork.item:New();
ITEM.name = "Empty Gas Can";
ITEM.uniqueID = "empty_gas_can";
ITEM.spawnValue = 11;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/props_junk/metalgascan.mdl";
ITEM.weight = 1;
ITEM.access = "jM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty metal gas can.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();