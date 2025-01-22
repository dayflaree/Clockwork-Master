local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Hazmat Uniform, Reinforced";
ITEM.uniqueID = "hazmat_uniform_reinforced";
ITEM.actualWeight = 5;
ITEM.invSpace = 6;
ITEM.protection = 0.15;
ITEM.maxArmor = 100;
ITEM.hasRebreather = true;
ITEM.isAnonymous = true;
ITEM.replacement = "models/lambdamovement_coat.mdl";
ITEM.description = "A lightweight uniform with a large helmet and a grey, camouflaged pattern. It has a rebreather attached to the helmet. It has been reinforced with tempered armor scraps to protect the user better.";
ITEM.repairItem = "tempered_armor_scraps";
ITEM.repairAmount = 80;
ITEM.business = false;
ITEM.access = "mMV";
ITEM.cost = 2000;

ITEM:AddData("Rarity", 3);

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	if (player:GetGender() == GENDER_FEMALE) then
		return "models/humans/airex/airex_female.mdl";
	else
		return "models/humans/airex/airex_male.mdl";
	end;
end;

ITEM:Register();