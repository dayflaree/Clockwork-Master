local ITEM = Clockwork.item:New();
ITEM.name = "Empty .357 Ammo Box";
ITEM.uniqueID = "empty_357_box";
ITEM.spawnValue = 6;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/Items/357ammo.mdl";
ITEM.weight = 0.35;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty carton box that used to contain .357 bullets.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();