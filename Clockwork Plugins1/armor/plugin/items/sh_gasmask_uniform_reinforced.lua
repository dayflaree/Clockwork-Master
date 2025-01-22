
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Gasmask Uniform, Reinforced";
ITEM.uniqueID = "gasmask_uniform_reinforced";
ITEM.actualWeight = 6.5;
ITEM.invSpace = 4;
ITEM.protection = 0.2;
ITEM.maxArmor = 110;
ITEM.hasGasmask = true;
ITEM.isAnonymous = true;
ITEM.replacement = "models/lambdamovement_coat.mdl";
ITEM.description = "A black resistance uniform, it has a white lambda on the sleeve and has a gas mask with it. It has been reinforced with additional armor scraps to provide better protection.";
ITEM.repairItem = "armor_scraps";
ITEM.business = false;
ITEM.access = "mMV";
ITEM.cost = 1000;

ITEM:AddData("Rarity", 3);

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	if (player:GetGender() == GENDER_FEMALE) then
		return "models/lambdamovement_female.mdl";
	else
		return "models/lambdamovement.mdl";
	end;
end;

ITEM:Register();