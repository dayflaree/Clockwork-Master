local ITEM = Clockwork.item:New();
ITEM.name = "Rusty AK47";
ITEM.uniqueID = "rusty_ak47";
ITEM.cost = 8;
ITEM.model = "models/weapons/w_ar1.mdl";
ITEM.weight = 3.5;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "A rusted AK47.";
ITEM.spawnValue = 1;
ITEM.isRareSpawn = true;

ITEM:AddData("Rarity", 3);

function ITEM:OnDrop(player, position) end;

ITEM:Register();