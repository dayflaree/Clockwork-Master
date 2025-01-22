
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Laborer Uniform";
ITEM.uniqueID = "laborer_uniform";
ITEM.spawnType = "misc";
ITEM.spawnValue = 3;
ITEM.actualWeight = 2;
ITEM.invSpace = 2;
ITEM.protection = 0.01;
ITEM.maxArmor = 0;
ITEM.description = "A laborer's uniform with gloves and a olive-green heavy jacket.";

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	local modelName = self:GetModelName(player);
	if (modelName == "male_10.mdl" or modelName == "male_11.mdl") then
		modelName = "male_01.mdl";
	end;

	return "models/betacz/group01/"..modelName;
end;

ITEM:Register();