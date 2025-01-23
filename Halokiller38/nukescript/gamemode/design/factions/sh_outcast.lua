local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	female = {
		"models/fallout_3/power_armor_outcast.mdl"
	},
	male = {
		"models/fallout_3/power_armor_outcast.mdl"
	};
};


FACTION_OUTCAST = blueprint.faction.Register(FACTION, "Brotherhood of Steel Outcast");