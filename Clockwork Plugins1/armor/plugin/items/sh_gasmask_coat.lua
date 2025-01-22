
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Gas mask Uniform, Coat";
ITEM.uniqueID = "coat_gasmask";
ITEM.actualWeight = 6;
ITEM.batch = 3;
ITEM.invSpace = 4;
ITEM.protection = 0.15;
ITEM.maxArmor = 100;
ITEM.hasGasmask = true;
ITEM.isAnonymous = true;
ITEM.replacement = "models/lambdamovement_coat.mdl";
ITEM.description = "A black resistance uniform with a coat, it has a white lambda on the sleeve and comes with a mandatory gasmask.";
ITEM.repairItem = "armor_scraps";
ITEM.business = true;
ITEM.access = "mMV";
ITEM.cost = 3333;

ITEM:AddData("Rarity", 2);

ITEM:Register();