
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Union HAZMAT suit";
ITEM.uniqueID = "union_hazmat_uniform";
ITEM.actualWeight = 2;
ITEM.batch = 3;
ITEM.invSpace = 2;
ITEM.protection = 0.05;
ITEM.maxArmor = 10;
ITEM.hasGasmask = true;
ITEM.isAnonymous = true;
ITEM.replacement = "models/nova prospekt/group22/group22scientist.mdl";
ITEM.description = "A thin, light-blue, Union made \"hazardous materials\" gas-mask suit, designed to protect against liquid and gaseous chemicals.";
ITEM.repairItem = "chunk_of_plastic";
ITEM.business = false;
ITEM.access = "U";
ITEM.cost = 500;

ITEM:AddData("Rarity", 2);

ITEM:Register();