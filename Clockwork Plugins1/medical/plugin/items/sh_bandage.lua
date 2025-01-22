
local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Gauze Bandage";
ITEM.uniqueID = "gauze_bandage";
ITEM.model = "models/warz/items/bandage.mdl";
ITEM.baseWeight = 0.25;
ITEM.healType = "bandage";
ITEM.healAmount = 40;
ITEM.healTime = 1800;
ITEM.stopHealOnFullHealth = true;
ITEM.description = "A sterile roll of gauze. There isn't much left, so use it sparingly.";
ITEM.spawnType = "medical";
ITEM.spawnValue = 50;
ITEM.business = true;
ITEM.access = "vVM";
ITEM.cost = 8;

function ITEM:CanUseItem(player)
	if (player:Health() == player:GetMaxHealth()) then
		return false;
	end;
end;

ITEM:Register();