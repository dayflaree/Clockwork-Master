local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	female = {
		"models/fallout_3/ghoul.mdl",
		"models/fallout_3/glowing_one.mdl"
	},
	male = {
		"models/fallout_3/ghoul.mdl",
		"models/fallout_3/glowing_one.mdl"
	};
};


FACTION_GHOUL = blueprint.faction.Register(FACTION, "Ghoul");