
local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "UU-Branded Bandage";
ITEM.uniqueID = "uu_bandage";
ITEM.model = "models/pg_props/pg_obj/pg_bandage.mdl";
ITEM.baseWeight = 0.25;
ITEM.healType = "bandage";
ITEM.healAmount = 30;
ITEM.healTime = 2400;
ITEM.category = "UU-Branded Items";
ITEM.stopHealOnFullHealth = true;
ITEM.description = "A sterile roll of gauze. There isn't much left, so use it sparingly.";
ITEM.spawnType = "medical";
ITEM.spawnValue = 50;
ITEM.business = true;
ITEM.access = "uU";
ITEM.cost = 7;

function ITEM:CanUseItem(player)
	if (player:Health() == player:GetMaxHealth()) then
		return false;
	end;
end;

ITEM:Register();