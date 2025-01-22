
local ITEM = Clockwork.item:New("armor_clothes_base");
ITEM.name = "Resistance Uniform";
ITEM.uniqueID = "resistance_uniform";
ITEM.isRareSpawn = true;
ITEM.spawnValue = 1;
ITEM.actualWeight = 4;
ITEM.invSpace = 3;
ITEM.protection = 0.2;
ITEM.maxArmor = 100;
ITEM.group = "group03";
ITEM.description = "A resistance uniform with a yellow symbol on the sleeve.";
ITEM.repairItem = "armor_scraps";
ITEM.business = true;
ITEM.access = "mMV";
ITEM.cost = 200;

ITEM:AddData("Rarity", 1);

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	if (string.lower( player:GetModel() ) == "models/humans/group01/male_bms_citizen_npc.mdl") then
		return "models/humans/group03/male_bms_rebel_npc.mdl";
	elseif (string.lower( player:GetModel() ) == "models/humans/group01/female_bms_citizen_npc.mdl") then
		return "models/humans/group03/female_bms_rebel_npc.mdl";
	end;
end;

ITEM:Register();