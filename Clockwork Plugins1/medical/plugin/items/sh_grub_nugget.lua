
local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Grub Nugget";
ITEM.uniqueID = "grub_nugget";
ITEM.model = "models/grub_nugget_small.mdl";
ITEM.baseWeight = 0.1;
ITEM.healType = "painkiller";
ITEM.healAmount = 25;
ITEM.healTime = 240;
ITEM.decayDelay = 600;
ITEM.decayTime = 2400;
ITEM.stopHealOnFullHealth = true;
ITEM.description = "A greasy, chunky nugget of Antlion Grub secretion. Works great as a temporary painkiller, but the feeling won't last.";

function ITEM:CanUseItem(player)
	if (player:Health() == player:GetMaxHealth()) then
		return false;
	end;
end;

ITEM:Register();