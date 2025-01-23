local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.singleGender = GENDER_MALE;
FACTION.models = {
	male = {
		"models/jessev92/PLAYER/ww2/hd_hitler_v3.mdl"
	};
};

FACTION_FUE = blueprint.faction.Register(FACTION, "Fuehrer");