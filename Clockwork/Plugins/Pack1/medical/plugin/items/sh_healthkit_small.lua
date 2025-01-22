
local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Medical Gel";
ITEM.uniqueID = "healthkit_small";
ITEM.model = "models/healthvial.mdl";
ITEM.baseWeight = 0.5;
ITEM.healType = "bandage";
ITEM.healAmount = 25;
ITEM.healTime = 480;
ITEM.stopHealOnFullHealth = true;
ITEM.amount = 1;
ITEM.description = "A small vial of medigel, a joint painkiller/coagulant. It needs time to fully coagulate.";
ITEM.spawnType = "medical";
ITEM.spawnValue = 15;
ITEM.business = true;
ITEM.access = "vVM";
ITEM.cost = 40;

function ITEM:CanUseItem(player)
	if (player:Health() == player:GetMaxHealth()) then
		return false;
	end;
end;

ITEM:Register();