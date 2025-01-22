local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Industrial Uniform, Reinforced";
ITEM.uniqueID = "industrial_uniform_reinforced";
ITEM.actualWeight = 7.5;
ITEM.invSpace = 3;
ITEM.protection = 0.10;
ITEM.maxArmor = 100;
ITEM.repairAmount = 100;
ITEM.hasGasmask = true;
ITEM.isAnonymous = true;
ITEM.replacement = "models/advindusuit/advindusuit.mdl";
ITEM.description = "A heavy aproned uniform with rubber gloves and a gasmask. It has been padded with additional cloth and armor scraps to protect the wearer better.";
ITEM.repairItem = "armor_scraps";
ITEM.business = false;
ITEM.access = "mMV";
ITEM.cost = 500;

ITEM:AddData("Rarity", 2);

ITEM:Register();