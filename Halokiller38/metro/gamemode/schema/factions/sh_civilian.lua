--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = {};

FACTION.useFullName = true;
FACTION.material = "severance/factions/survivor";
FACTION.models = {
	female = {
		"models/humans/group34/female_01.mdl",
		"models/humans/group34/female_02.mdl",
		"models/humans/group34/female_03.mdl",
		"models/humans/group34/female_04.mdl",
		"models/humans/group34/female_05.mdl",
		"models/humans/group34/female_06.mdl",
		"models/humans/group34/female_07.mdl",
		"models/humans/group34/female_08.mdl",
		"models/humans/group34/female_09.mdl",
		"models/humans/group35/female_01.mdl",
		"models/humans/group35/female_02.mdl",
		"models/humans/group35/female_03.mdl",
		"models/humans/group35/female_04.mdl",
		"models/humans/group35/female_05.mdl",
		"models/humans/group35/female_06.mdl",
		"models/humans/group35/female_07.mdl",
		"models/humans/group35/female_08.mdl",
		"models/humans/group35/female_09.mdl",
		"models/humans/group36/female_01.mdl",
		"models/humans/group36/female_02.mdl",
		"models/humans/group36/female_03.mdl",
		"models/humans/group36/female_04.mdl",
		"models/humans/group36/female_05.mdl",
		"models/humans/group36/female_06.mdl",
		"models/humans/group36/female_07.mdl",
		"models/humans/group36/female_08.mdl",
		"models/humans/group36/female_09.mdl"
	},
	male = {
		"models/humans/group34/male_01.mdl",
		"models/humans/group34/male_02.mdl",
		"models/humans/group34/male_03.mdl",
		"models/humans/group34/male_04.mdl",
		"models/humans/group34/male_05.mdl",
		"models/humans/group34/male_06.mdl",
		"models/humans/group34/male_07.mdl",
		"models/humans/group34/male_08.mdl",
		"models/humans/group34/male_09.mdl",
		"models/humans/group35/male_01.mdl",
		"models/humans/group35/male_02.mdl",
		"models/humans/group35/male_03.mdl",
		"models/humans/group35/male_04.mdl",
		"models/humans/group35/male_05.mdl",
		"models/humans/group35/male_06.mdl",
		"models/humans/group35/male_07.mdl",
		"models/humans/group35/male_08.mdl",
		"models/humans/group35/male_09.mdl",
		"models/humans/group36/male_01.mdl",
		"models/humans/group36/male_02.mdl",
		"models/humans/group36/male_03.mdl",
		"models/humans/group36/male_04.mdl",
		"models/humans/group36/male_05.mdl",
		"models/humans/group36/male_06.mdl",
		"models/humans/group36/male_07.mdl",
		"models/humans/group36/male_08.mdl",
		"models/humans/group36/male_09.mdl"
	};
};

FACTION_CIVILIAN = openAura.faction:Register(FACTION, "Survivor");