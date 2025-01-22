
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Hidden Kevlar Vest";
ITEM.uniqueID = "hidden_kevlar_vest";
ITEM.actualWeight = 3;
ITEM.invSpace = 0;
ITEM.business = true;
ITEM.access = "mMV";
ITEM.protection = 0.05;
ITEM.maxArmor = 75;
ITEM.description = "A lightweight ballistic vest small enough to be concealed beneath regular clothing and still provide reliable protection.";
ITEM.cost = 600;

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	if (SERVER) then
		return player:GetDefaultModel();
	else
		return player:GetModel();
	end;
end;

ITEM:Register();