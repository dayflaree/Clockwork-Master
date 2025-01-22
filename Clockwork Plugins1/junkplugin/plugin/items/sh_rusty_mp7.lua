local ITEM = Clockwork.item:New();
ITEM.name = "Rusty MP7";
ITEM.spawnValue = 1;
ITEM.spawnType = "crafting";
ITEM.cost = 8;
ITEM.model = "models/Weapons/w_smg1.mdl";
ITEM.weight = 2;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "A rusted Heckler and Koch MP7.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();