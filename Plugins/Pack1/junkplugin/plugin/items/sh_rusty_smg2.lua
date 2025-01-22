local ITEM = Clockwork.item:New();
ITEM.name = "Rusty MP5K";
ITEM.uniqueID = "rusty_smg2";
ITEM.cost = 8;
ITEM.model = "models/weapons/w_smg2.mdl";
ITEM.weight = 2.5;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "A worn and broken mp5k.";
ITEM.spawnValue = 1;
ITEM.spawnType = "crafting";

ITEM:AddData("Rarity", 2);

function ITEM:OnDrop(player, position) end;

ITEM:Register();