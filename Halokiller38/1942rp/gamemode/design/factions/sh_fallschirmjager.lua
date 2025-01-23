local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.singleGender = GENDER_MALE;
FACTION.models = {
	male = {
		"models/player/BTZgerman/ukdkhr_mg_player.mdl",
		"models/player/BTZgerman/fallshirmjager.mdl",
		"models/player/BTZgerman/decayg_sniper_player.mdl",
		"models/player/BTZgerman/decayg_rocket_player.mdl",
		"models/player/BTZgerman/decayg_assault_player.mdl"
	};
};

FACTION_FALL = blueprint.faction.Register(FACTION, "Fallschirmjager");