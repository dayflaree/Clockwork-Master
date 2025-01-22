
local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Paracetamol";
ITEM.uniqueID = "paracetamol";
ITEM.model = "models/warz/consumables/medicine.mdl";
ITEM.useWeight = 0;
ITEM.baseWeight = 0.2;
ITEM.healType = "painkiller";
ITEM.healAmount = 25;
ITEM.healTime = 240;
ITEM.decayDelay = 900;
ITEM.decayTime = 480;
ITEM.description = "An old prescription medicine bottle, containing a few tablets of acetaminophen. Ideal for staving off mild to moderate pain, with minimal risk of overdose or addiction.";
ITEM.amount = 2;
ITEM.spawnType = "medical";
ITEM.spawnValue = 24;
ITEM.business = true;
ITEM.access = "vVM";
ITEM.cost = 20;

ITEM:Register();