--[[
Name: "sh_fleet.lua".
Product: "Starship Troopers".
--]]

local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	female = {
		"models/mobileinfantry/fme_01.mdl",
		"models/mobileinfantry/fme_02.mdl",
		"models/mobileinfantry/fme_03.mdl",
		"models/mobileinfantry/fme_04.mdl",
		"models/mobileinfantry/fme_06.mdl",
		"models/mobileinfantry/fme_07.mdl"
	},
	
	male = {
		"models/mobileinfantry/me_01.mdl",
		"models/mobileinfantry/me_02.mdl",
		"models/mobileinfantry/me_03.mdl",
		"models/mobileinfantry/me_04.mdl",
		"models/mobileinfantry/me_05.mdl",
		"models/mobileinfantry/me_06.mdl",
		"models/mobileinfantry/me_07.mdl",
		"models/mobileinfantry/me_08.mdl",
		"models/mobileinfantry/me_09.mdl",
		"models/mobileinfantry/me_10.mdl",
		"models/mobileinfantry/me_11.mdl",
		"models/mobileinfantry/me_12.mdl",
		"models/mobileinfantry/me_13.mdl",
		"models/mobileinfantry/me_14.mdl",
		"models/mobileinfantry/me_15.mdl",
		"models/mobileinfantry/me_16.mdl",
		"models/mobileinfantry/me_17.mdl",
		"models/mobileinfantry/me_18.mdl"
		
		
	}
};

FACTION_FLEET = nexus.faction.Register(FACTION, "Federation Fleet");