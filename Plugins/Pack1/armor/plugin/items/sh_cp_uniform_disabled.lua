local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Disabled Civil Protection Uniform";
ITEM.uniqueID = "civil_protection_uniform_disabled";
ITEM.actualWeight = 6;
ITEM.invSpace = 4;
ITEM.protection = 0.18;
ITEM.repairAmount = 100
ITEM.maxArmor = 100;
ITEM.hasGasmask = true;
ITEM.isAnonymous = true;
ITEM.replacement = "models/dpfilms/metropolice/hdpolice.mdl";
ITEM.description = "A captured CiviPro uniform. Minor charring on the fabric indicates its trackers have been disabled by the application of high-voltage electricity.";
ITEM.repairItem = "kevlar_vest_acp";

ITEM:Register();