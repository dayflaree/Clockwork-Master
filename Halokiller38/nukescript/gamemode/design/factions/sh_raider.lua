local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
		female = {
		"models/Fallout3/painspikefemaleraider.mdl",
		"models/Fallout3/sadistfemaleraider.mdl"
	},
	male = {
		"models/Fallout3/sadistmaleraider.mdl"
	};
};

FACTION_RAIDER = blueprint.faction.Register(FACTION, "Raiders");