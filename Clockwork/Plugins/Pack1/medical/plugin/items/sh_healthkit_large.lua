
local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Medical Supply Bag";
ITEM.uniqueID = "healthkit_large";
ITEM.model = "models/warz/items/medkit.mdl";
ITEM.baseWeight = 2;
ITEM.healType = "bandage";
ITEM.healAmount = 75;
ITEM.healTime = 600;
ITEM.stopHealOnFullHealth = true;
ITEM.amount = 7;
ITEM.description = "A camo bag with a medical cross, containing a plethora of medical supplies for repeated healing capabilities.";
ITEM.spawnType = "medical";
ITEM.spawnValue = 4;
ITEM.business = true;
ITEM.access = "VM";
ITEM.cost = 150;
ITEM.batch = 3;

function ITEM:CanUseItem(player)
	if (player:Health() == player:GetMaxHealth()) then
		return false;
	end;
end;

ITEM:Register();