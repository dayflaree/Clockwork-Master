--[[
Name: "sh_civilian_insurgency.lua".
Product: "Novus Two".
--]]

local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	female = {
		"models/humans/group98/female_01.mdl",
		"models/humans/group98/female_02.mdl",
		"models/humans/group98/female_03.mdl",
		"models/humans/group98/female_04.mdl",
		"models/humans/group98/female_06.mdl",
		"models/humans/group98/female_07.mdl"
	},
	male = {
		"models/humans/group98/male_01.mdl",
		"models/humans/group98/male_02.mdl",
		"models/humans/group98/male_03.mdl",
		"models/humans/group98/male_04.mdl",
		"models/humans/group98/male_05.mdl",
		"models/humans/group98/male_06.mdl",
		"models/humans/group98/male_07.mdl",
		"models/humans/group98/male_08.mdl",
		"models/humans/group98/male_09.mdl"
	};
};

FACTION_INSURGENCY = nexus.faction.Register(FACTION, "Civilian Insurgency");