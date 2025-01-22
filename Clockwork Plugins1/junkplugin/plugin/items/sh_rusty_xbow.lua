local ITEM = Clockwork.item:New();
ITEM.name = "Rusty Crossbow";
ITEM.uniqueID = "rusty_crossbow";
ITEM.spawnValue = 1;
ITEM.isRareSpawn = true;
ITEM.cost = 8;
ITEM.model = "models/Weapons/W_crossbow.mdl";
ITEM.weight = 4;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "A rusted Resistance Crossbow.";


function ITEM:OnDrop(player, position) end;

ITEM:Register();