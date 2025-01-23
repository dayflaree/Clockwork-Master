local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.singleGender = GENDER_MALE;
FACTION.models = {
	male = {
		"models/Half-Dead/Soviet/russian_01.mdl",
		"models/Half-Dead/Soviet/russian_02.mdl",
		"models/Half-Dead/Soviet/russian_03.mdl",
		"models/Half-Dead/Soviet/russian_04.mdl",
		"models/Half-Dead/Soviet/russian_05.mdl"
	};
};

FACTION_RA = blueprint.faction.Register(FACTION, "Red Army");