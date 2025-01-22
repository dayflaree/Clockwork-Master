
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Reinforced Gas mask Uniform, Coat";
ITEM.uniqueID = "coat_gasmask_reinforced";
ITEM.actualWeight = 6.5;
ITEM.invSpace = 4;
ITEM.protection = 0.25;
ITEM.maxArmor = 100;
ITEM.repairAmount = 50
ITEM.hasGasmask = true;
ITEM.isAnonymous = true;
ITEM.replacement = "models/lambdamovement_coat.mdl";
ITEM.description = "A black resistance uniform with a coat, it has a white lambda on the sleeve and comes with a mandatory gasmask. The armguards, shoulders and knee shins have been reinforced with additional armor scraps for increased durability.";
ITEM.repairItem = "armor_scraps";
ITEM.business = false;
ITEM.access = "mMV";
ITEM.cost = 1000;

ITEM:AddData("Rarity", 2);

ITEM:Register();