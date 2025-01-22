local ITEM = Clockwork.item:New();
ITEM.name = "Empty Buckshot Ammo Box";
ITEM.uniqueID = "empty_shotgun_box";
ITEM.spawnValue = 4;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/Items/BoxBuckshot.mdl";
ITEM.weight = 0.5;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty carton box that used to contain buckshot pellets.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();