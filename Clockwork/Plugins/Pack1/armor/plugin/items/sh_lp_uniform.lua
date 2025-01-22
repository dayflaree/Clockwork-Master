
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Loyalist Party Uniform";
ITEM.uniqueID = "lp_uniform";
ITEM.actualWeight = 2;
ITEM.invSpace = 2;
ITEM.protection = 0.01;
ITEM.maxArmor = 0;
ITEM.description = "A clean shirt with the City logo printed on it.";

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	local modelName = self:GetModelName(player);
	if (modelName == "male_10.mdl" or modelName == "male_11.mdl") then
		modelName = "male_01.mdl";
	end;

	return "models/humans/office1/"..modelName;
end;

ITEM:Register();