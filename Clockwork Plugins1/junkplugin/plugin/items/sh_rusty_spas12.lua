local ITEM = Clockwork.item:New();
ITEM.name = "Rusty SPAS-12";
ITEM.cost = 8;
ITEM.model = "models/Weapons/w_shotgun.mdl";
ITEM.uniqueID = "rusty_spas12";
ITEM.weight = 4;
ITEM.spawnValue = 1;
ITEM.isRareSpawn = true;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "A rusted 12 Gauge SPAS-12.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();