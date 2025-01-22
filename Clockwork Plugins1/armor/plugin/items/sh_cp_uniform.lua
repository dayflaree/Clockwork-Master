local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Civil Protection Uniform";
ITEM.uniqueID = "civil_protection_uniform";
ITEM.actualWeight = 6;
ITEM.invSpace = 4;
ITEM.protection = 0.20;
ITEM.repairAmount = 100
ITEM.maxArmor = 100;
ITEM.hasGasmask = true;
ITEM.replacement = "models/dpfilms/metropolice/hdpolice.mdl";
--ITEM.replacement = "models/dpfilms/metropolice/female_police.mdl";
ITEM.description = "A durable Civil Protector's uniform, standard issue for City 18. Its protective kevlar contains impact trauma sensors and locational trackers.";
ITEM.repairItem = "kevlar_vest_acp";
ITEM.isCombineSuit = true;
ITEM.isAnonymous = true;

ITEM:Register();