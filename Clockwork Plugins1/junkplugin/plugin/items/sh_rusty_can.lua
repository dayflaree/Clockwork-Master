
local ITEM = Clockwork.item:New();
ITEM.name = "Rusty Can";
ITEM.uniqueID = "rusty_can";
ITEM.spawnValue = 50;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/props_junk/garbage_metalcan002a.mdl";
ITEM.weight = 0.2;
ITEM.access = "jM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "A rusted tin can.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();