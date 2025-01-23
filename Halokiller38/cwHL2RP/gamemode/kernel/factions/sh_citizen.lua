--[[
	Free Clockwork!
--]]

local FACTION = {};

FACTION.useFullName = false;
FACTION.models = {
	female = {
		"models/humans/group01/female_01.mdl",
		"models/humans/group01/female_02.mdl",
		"models/humans/group01/female_03.mdl",
		"models/humans/group01/female_04.mdl",
		"models/humans/group01/female_06.mdl",
		"models/humans/group01/female_07.mdl"
	},
	male = {
		"models/humans/group01/male_01.mdl",
		"models/humans/group01/male_02.mdl",
		"models/humans/group01/male_03.mdl",
		"models/humans/group01/male_04.mdl",
		"models/humans/group01/male_05.mdl",
		"models/humans/group01/male_06.mdl",
		"models/humans/group01/male_07.mdl",
		"models/humans/group01/male_08.mdl",
		"models/humans/group01/male_09.mdl",
	};
};

FACTION_CITIZEN = Clockwork.faction:Register(FACTION, "Citizen");