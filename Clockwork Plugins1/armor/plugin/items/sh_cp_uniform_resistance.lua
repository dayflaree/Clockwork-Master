local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Resistance CP Uniform";
ITEM.uniqueID = "cp_uniform_resistance";
ITEM.actualWeight = 8;
ITEM.invSpace = 6;
ITEM.protection = 0.25;
ITEM.repairAmount = 100
ITEM.maxArmor = 100;
ITEM.hasGasmask = true;
ITEM.isAnonymous = true;
ITEM.replacement = "models/dpfilms/metropolice/resistance_police.mdl";
ITEM.description = "A customized CP uniform, resprayed with a resistance logo and modified to include better damage resistance.";
ITEM.repairItem = "kevlar_vest_acp";

ITEM:Register();