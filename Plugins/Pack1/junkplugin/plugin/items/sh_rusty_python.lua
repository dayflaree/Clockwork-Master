local ITEM = Clockwork.item:New();
ITEM.name = "Rusty Python";
ITEM.cost = 8;
ITEM.spawnValue = 1;
ITEM.isRareSpawn = true;
ITEM.model = "models/Weapons/W_357.mdl";
ITEM.weight = 1;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "A rusted Colt Python.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();