local ITEM = Clockwork.item:New();
ITEM.name = "Rusty MP40";
ITEM.uniqueID = "rusty_mp40";
ITEM.cost = 8;
ITEM.model = "models/weapons/w_mp40.mdl";
ITEM.weight = 3.2;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "A rusted MP40 from World War II. Does this thing even work?";
ITEM.spawnValue = 1;
ITEM.spawnType = "crafting";

function ITEM:OnDrop(player, position) end;

ITEM:Register();