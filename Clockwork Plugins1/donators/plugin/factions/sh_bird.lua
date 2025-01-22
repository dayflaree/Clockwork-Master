
-----------------------------------------------------

local FACTION = Clockwork.faction:New("Bird")
FACTION.whitelist = true;
FACTION.useFullName = true;
FACTION.models = {
		male = {
				"models/pigeon.mdl",
				"models/crow.mdl",
				"models/seagull.mdl"
				};
		female = {
				"models/pigeon.mdl",
				"models/crow.mdl",
				"models/seagull.mdl"
				};
};

-- NPC Relations, where you can set NPC's that are supposed to be friendly with the faction.
FACTION.npcRelations = {
        ["npc_zombie"] = D_NU,
        ["npc_poisonzombie"] = D_NU,
		["npc_zombie_torso"] = D_NU,
		["npc_headcrab_black"] = D_HT,
		["npc_headcrab"] = D_HT,
		["npc_fastzombie_torso"] = D_NU,
		["npc_fastzombie"] = D_NU,
		["npc_headcrab_fast"] = D_HT,
		["npc_antlion"] = D_NU,
		["npc_antlionguard"] = D_NU,
		["npc_combine_s"] = D_NU,
		["npc_metropolice"] = D_NU,
		["npc_combine_sniper"] = D_HT
};

--Called when a player's model should be assigned to the faction.
function FACTION:GetModel(player, character)
	if(character.gender == GENDER_MALE) then
		return self.models.male[1];
	else
		return self.models.female[1];
	end;
end;

FACTION_BIRD = FACTION:Register();
