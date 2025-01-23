local FACTION = {};

FACTION.singleGender = GENDER_MALE;
FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	male = {
		"models/CL/Military/legionrecruit.mdl"
	};
};

FACTION_CL = blueprint.faction.Register(FACTION, "Caesar's Legion");