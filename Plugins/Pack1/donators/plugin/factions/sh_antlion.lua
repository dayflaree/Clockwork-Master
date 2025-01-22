
-----------------------------------------------------

local FACTION = Clockwork.faction:New("Antlion")
FACTION.whitelist = true;
FACTION.useFullName = true;
FACTION.models = {
		male = {"models/AntLion.mdl"},
		female = {"models/AntLion.mdl"}
};

-- NPC Relations, where you can set NPC's that are supposed to be friendly with the faction.
FACTION.npcRelations = {
        ["npc_zombie"] = D_HT,
        ["npc_poisonzombie"] = D_HT,
	["npc_zombie_torso"] = D_HT,
	["npc_headcrab_black"] = D_HT,
	["npc_headcrab"] = D_HT,
	["npc_fastzombie_torso"] = D_HT,
	["npc_fastzombie"] = D_HT,
	["npc_headcrab_fast"] = D_HT,
	["npc_antlion"] = D_NU,
	["npc_antlionguard"] = D_NU,
	["npc_antlionworker"] = D_NU
};

--Called when a player's model should be assigned to the faction.
function FACTION:GetModel(player, character)
	if(character.gender == GENDER_MALE) then
		return self.models.male[1];
	else
		return self.models.female[1];
	end;
end;

FACTION_ANTLION = FACTION:Register();
