local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
		female = {
		"models/Humans/Group03/Female_01.mdl",
		"models/Humans/Group03/Female_02.mdl",
		"models/Humans/Group03/Female_03.mdl",
		"models/Humans/Group03/Female_04.mdl",
		"models/Humans/Group03/Female_06.mdl",
		"models/Humans/Group03/Female_07.mdl"
	},
	male = {
		"models/ncr/ncr_01.mdl",
		"models/ncr/ncr_02.mdl",
		"models/ncr/ncr_03.mdl",
		"models/ncr/ncr_04.mdl",
		"models/ncr/ncr_05.mdl",
		"models/ncr/ncr_06.mdl",
		"models/ncr/ncr_07.mdl",
		"models/ncr/ncr_08.mdl",
		"models/ncr/ncr_09.mdl"
	};
};

FACTION_NCR = blueprint.faction.Register(FACTION, "New California Republic");