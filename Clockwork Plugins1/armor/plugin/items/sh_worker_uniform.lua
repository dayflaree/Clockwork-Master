
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Worker Uniform";
ITEM.uniqueID = "worker_uniform";
ITEM.spawnType = "misc";
ITEM.spawnValue = 3;
ITEM.actualWeight = 2;
ITEM.invSpace = 2;
ITEM.protection = 0.01;
ITEM.maxArmor = 0;
ITEM.description = "A worker's uniform with a symbol marking City 17.";

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	local modelName = self:GetModelName(player);
	if (modelName == "male_10.mdl" or modelName == "male_11.mdl") then
		modelName = "male_01.mdl";
	end;
	
	return "models/humans/factory/"..modelName;
end;

ITEM:Register();