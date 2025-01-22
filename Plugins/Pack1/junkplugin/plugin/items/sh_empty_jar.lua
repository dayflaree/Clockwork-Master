local ITEM = Clockwork.item:New();
ITEM.name = "Empty Jar";
ITEM.uniqueID = "empty_jar";
ITEM.spawnValue = 30;
ITEM.spawnType = "junk";
ITEM.cost = 6;
ITEM.model = "models/props_lab/jar01a.mdl";
ITEM.weight = 0.2;
ITEM.access = "jM";
ITEM.business = false;
ITEM.category = "Junk";
ITEM.description = "An empty plastic jar.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();