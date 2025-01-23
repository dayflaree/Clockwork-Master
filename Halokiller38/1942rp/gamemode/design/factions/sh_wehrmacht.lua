local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.singleGender = GENDER_MALE;
FACTION.models = {
	male = {
		"models/player/BTZgerman/ukdkhr_support_player.mdl"
	};
};

FACTION_WEHR = blueprint.faction.Register(FACTION, "Wehrmacht");