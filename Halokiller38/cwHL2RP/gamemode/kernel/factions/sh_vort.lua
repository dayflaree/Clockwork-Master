--[[
	Free Clockwork!
--]]

local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	female = {
		"models/vortigaunt_slave.mdl"
	},
	male = {
		"models/vortigaunt_slave.mdl"
	};
};

FACTION_VORT = Clockwork.faction:Register(FACTION, "Vortigaunt");