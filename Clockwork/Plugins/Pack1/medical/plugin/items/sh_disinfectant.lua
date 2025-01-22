local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Disinfectant";
ITEM.uniqueID = "disinfectant";
ITEM.model = "models/props_junk/glassjug01.mdl";
ITEM.useWeight = 0.05;
ITEM.baseWeight = 0.2;
ITEM.healType = "disinfectant";
ITEM.healAmount = 15;
ITEM.healTime = 1200;
ITEM.amount = 10;
ITEM.description = "A bottle of disinfectant designed to clean and sterilize wounds.";

ITEM:Register();