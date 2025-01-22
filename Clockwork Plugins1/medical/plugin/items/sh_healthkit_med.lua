
local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Medical Kit";
ITEM.uniqueID = "healthkit_med";
ITEM.model = "models/items/healthkit.mdl";
ITEM.baseWeight = 1;
ITEM.healType = "bandage";
ITEM.healAmount = 50;
ITEM.healTime = 720;
ITEM.stopHealOnFullHealth = true;
ITEM.amount = 2;
ITEM.description = "A compact kit containing a vial of medigel alongside some basic medical supplies, good for a decent patch job.";
ITEM.spawnType = "medical";
ITEM.spawnValue = 10;
ITEM.business = true;
ITEM.access = "vVM";
ITEM.cost = 70;

ITEM:Register();