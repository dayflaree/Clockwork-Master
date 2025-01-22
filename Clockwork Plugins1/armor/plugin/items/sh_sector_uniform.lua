local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Sector Uniform";
ITEM.spawnValue = 3;
ITEM.spawnType = "misc";
ITEM.uniqueID = "sector_uniform";
ITEM.actualWeight = 2;
ITEM.invSpace = 2;
ITEM.protection = 0.01;
ITEM.maxArmor = 0;
ITEM.description = "A sector uniform with a heavy, beige jacket and linen pants.";

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	local modelName = self:GetModelName(player);
	if (modelName == "male_10.mdl" or modelName == "male_11.mdl") then
		modelName = "male_01.mdl";
	end;
	
	return "models/betacz/group03/"..modelName;
end;

ITEM:Register();