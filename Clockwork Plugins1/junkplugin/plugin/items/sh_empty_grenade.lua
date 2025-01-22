local ITEM = Clockwork.item:New();
ITEM.name = "Empty Grenade";
ITEM.spawnValue = 12;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/Items/grenadeAmmo.mdl";
ITEM.weight = 0.5;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty grenade, feels like a tube of dust.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();