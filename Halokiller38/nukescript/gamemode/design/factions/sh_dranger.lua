local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
		female = {
		"models/fallout_nv/nikout/LonesomeRoad/riotsoldier.mdl"
	},
	male = {
		"models/fallout_nv/nikout/LonesomeRoad/riotsoldier.mdl"
	};
};

FACTION_DRANGER = blueprint.faction.Register(FACTION, "Desert Ranger");