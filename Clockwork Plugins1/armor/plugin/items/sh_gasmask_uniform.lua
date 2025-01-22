
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Gas mask Uniform";
ITEM.uniqueID = "gasmask_uniform";
ITEM.actualWeight = 6;
ITEM.invSpace = 4;
ITEM.protection = 0.15;
ITEM.maxArmor = 100;
ITEM.hasGasmask = true;
ITEM.isAnonymous = true;
ITEM.replacement = "models/lambdamovement_coat.mdl";
ITEM.description = "An armored black-colored resistance uniform, made of salvaged kevlar and bits of cloth, with a functional gas mask.";
ITEM.repairItem = "armor_scraps";
ITEM.business = true;
ITEM.access = "mMV";
ITEM.cost = 1500;
ITEM.batch = 3;

ITEM:AddData("Rarity", 2);

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	if (player:GetGender() == GENDER_FEMALE) then
		return "models/lambdamovement_female.mdl";
	else
		return "models/lambdamovement.mdl";
	end;
end;

ITEM:Register();