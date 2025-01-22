
-----------------------------------------------------
local FACTION = Clockwork.faction:New("Zombie");

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.noGas  = true;
FACTION.models = {
	female = {
		"models/Zombie/Classic.mdl",
	},
	male = {
		"models/Zombie/Classic.mdl",
	};
};

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name != FACTION_CITIZEN) then
		return false;
	end;
end;

-- NPC Relations, where you can set NPC's that are supposed to be friendly with the faction.
FACTION.npcRelations = {
	["npc_zombie"] = D_NU,
	["npc_poisonzombie"] = D_NU,
	["npc_zombie_torso"] = D_NU,
	["npc_headcrab_black"] = D_NU,
	["npc_headcrab"] = D_NU,
	["npc_fastzombie_torso"] = D_NU,
	["npc_fastzombie"] = D_NU,
	["npc_headcrab_fast"] = D_NU,
	["npc_zombine"] = D_NU,
	["npc_antlion"] = D_HT,
	["npc_antlionguard"] = D_HT
};

FACTION_ZOMBIE = FACTION:Register();