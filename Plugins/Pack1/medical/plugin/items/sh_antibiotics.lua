
local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Broad-Spectrum Antibiotics";
ITEM.uniqueID = "antibiotics";
ITEM.model = "models/props_junk/garbage_metalcan002a.mdl";
ITEM.useWeight = 0;
ITEM.baseWeight = 0.2;
ITEM.healType = "antibiotic";
ITEM.healAmount = 20;
ITEM.healTime = 1800;
ITEM.amount = 8;
ITEM.description = "A bottle of pharmacy-brand antibiotics, still sealed tightly.";
ITEM.spawnType = "medical";
ITEM.spawnValue = 7;
ITEM.business = true;
ITEM.access = "vVM";
ITEM.cost = 40;

ITEM:Register();