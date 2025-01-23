--[[
Name: "sh_administrator.lua".
Product: "Half-Life 2".
--]]

local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	female = {
		"models/humans/group17/female_01.mdl",
		"models/humans/group17/female_02.mdl",
		"models/humans/group17/female_03.mdl",
		"models/humans/group17/female_04.mdl",
		"models/humans/group17/female_06.mdl",
		"models/humans/group17/female_07.mdl"
	},
	male = {
		"models/humans/group17/male_01.mdl",
		"models/humans/group17/male_02.mdl",
		"models/humans/group17/male_03.mdl",
		"models/humans/group17/male_04.mdl",
		"models/humans/group17/male_05.mdl",
		"models/humans/group17/male_06.mdl",
		"models/humans/group17/male_07.mdl",
		"models/humans/group17/male_08.mdl",
		"models/humans/group17/male_09.mdl"
	};
};

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name != FACTION_CITIZEN) then
		return false;
	end;
end;

FACTION_ADMIN = resistance.faction.Register(FACTION, "Administrator");