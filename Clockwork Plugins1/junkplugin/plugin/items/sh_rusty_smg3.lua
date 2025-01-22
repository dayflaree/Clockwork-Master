local ITEM = Clockwork.item:New();
ITEM.name = "Rusty MP7A1";
ITEM.uniqueID = "rusty_smg3";
ITEM.cost = 8;
ITEM.model = "models/weapons/w_beta_mp7.mdl";
ITEM.weight = 2.5;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "A jammed and battered MP7A1.";
ITEM.spawnValue = 1;
ITEM.isRareSpawn = true;

ITEM:AddData("Rarity", 2);

function ITEM:OnDrop(player, position) end;

ITEM:Register();