
local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Morphine";
ITEM.uniqueID = "morphine";
ITEM.model = "models/warz/items/syringe.mdl";
ITEM.useWeight = 0;
ITEM.baseWeight = 0.2;
ITEM.blurTime = 1200;
ITEM.healType = "painkiller";
ITEM.healAmount = 150;
ITEM.healTime = 60;
ITEM.stopHealOnFullHealth = false;
ITEM.decayDelay = 1200;
ITEM.decayTime = 120;
ITEM.description = "An auto-injector containing 10cc of field-grade morphine. Incredibly strong and easy to overdose on, though its painkilling properties are second-to-none.";
ITEM.spawnType = "medical";
ITEM.spawnValue = 1;
ITEM.business = true;
ITEM.access = "VM";
ITEM.cost = 75;
ITEM.batch = 3;

function ITEM:OnMedicalItemUsed(player, itemEntity)
	player:SetSharedVar("morphine", CurTime() + 1200);
end;

ITEM:Register();