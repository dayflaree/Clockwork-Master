local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	female = {
		"models/f3alien/slow.mdl"
	},
	male = {
		"models/f3alien/slow.mdl"
	};
};

FACTION_ALIENS = blueprint.faction.Register(FACTION, "Aliens");