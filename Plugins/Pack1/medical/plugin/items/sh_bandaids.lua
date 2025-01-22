
local ITEM = Clockwork.item:New("medical_base");
ITEM.name = "Box of Band-aids";
ITEM.uniqueID = "bandaids";
ITEM.model = "models/props_junk/cardboard_box004a.mdl";
ITEM.useWeight = 0;
ITEM.baseWeight = 0.5;
ITEM.amount = 10;
ITEM.healType = "bandage";
ITEM.healAmount = 5;
ITEM.healTime = 30;
ITEM.stopHealOnFullHealth = true;
ITEM.description = "A box of Hello Kitty band-aids, for your booboos and ouchies.";
ITEM.spawnType = "medical";
ITEM.spawnValue = 35;
ITEM.business = true;
ITEM.access = "vVM";
ITEM.cost = 35;

function ITEM:CanUseItem(player)
	if (player:Health() == player:GetMaxHealth()) then
		return false;
	end;
end;

ITEM:Register();