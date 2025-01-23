local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
		female = {
		"models/ncr/rangercombatarmor.mdl"
	},
	male = {
		"models/ncr/rangercombatarmor.mdl"
	};
};

FACTION_RANGER = blueprint.faction.Register(FACTION, "New California Republic Ranger");