
local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Threaded Hemostat";
ITEM.uniqueID = "hemostat";
ITEM.model = "models/props_c17/trappropeller_lever.mdl";
ITEM.useWeight = 0;
ITEM.baseWeight = 0.1;
ITEM.blurTime = 30;
ITEM.healType = "antibiotics";
ITEM.healAmount = 10;
ITEM.healTime = 20;
ITEM.useSound = "weapons/knife/knife_hit2.wav";
ITEM.stopHealOnFullHealth = true;
ITEM.description = "A hemostatic needle, threaded with sterile thread. Great as a quick-fix but not the most effective way of getting patched up.";
ITEM.spawnType = "medical";
ITEM.spawnValue = 17;
ITEM.business = true;
ITEM.access = "vVM";
ITEM.cost = 20;

function ITEM:CanUseItem(player)
	if (player:Health() == player:GetMaxHealth()) then
		return false;
	end;
end;

ITEM:Register();