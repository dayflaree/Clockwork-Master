local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Industrial Uniform";
ITEM.uniqueID = "industrial_uniform";
ITEM.spawnValue = 1;
ITEM.isRareSpawn = true;
ITEM.actualWeight = 7;
ITEM.invSpace = 3;
ITEM.protection = 0.05;
ITEM.maxArmor = 75;
ITEM.repairAmount = 40;
ITEM.hasGasmask = true;
ITEM.isAnonymous = true;
ITEM.replacement = "models/indusuit/indusuit.mdl";
ITEM.description = "A heavy aproned uniform with rubber gloves and a gasmask.";
ITEM.repairItem = "cloth_scraps";
ITEM.business = false;
ITEM.access = "mMV";
ITEM.cost = 500;

ITEM:AddData("Rarity", 1);

ITEM:Register();