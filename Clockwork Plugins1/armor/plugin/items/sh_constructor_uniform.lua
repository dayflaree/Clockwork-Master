local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Constructor Uniform";
ITEM.spawnValue = 3;
ITEM.spawnType = "misc";
ITEM.uniqueID = "constructor_uniform";
ITEM.actualWeight = 2;
ITEM.invSpace = 2;
ITEM.protection = 0.01;
ITEM.maxArmor = 0;
ITEM.description = "A constructor uniform with gloves and a blue heavy jacket.";

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	local modelName = self:GetModelName(player);
	if (modelName == "male_10.mdl" or modelName == "male_11.mdl") then
		modelName = "male_01.mdl";
	end;
	
	return "models/betacz/group02/"..modelName;
end;

ITEM:Register();