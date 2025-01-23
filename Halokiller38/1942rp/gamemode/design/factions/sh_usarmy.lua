local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.singleGender = GENDER_MALE;
FACTION.models = {
	male = {
		"models/jessev92/PLAYER/biahh/bia1.mdl"
	};
};

FACTION_US = blueprint.faction.Register(FACTION, "The United States of America");