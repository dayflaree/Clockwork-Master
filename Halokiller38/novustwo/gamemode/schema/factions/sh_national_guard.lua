--[[
Name: "sh_national_guard.lua".
Product: "Novus Two".
--]]

local FACTION = {};

FACTION.singleGender = GENDER_MALE;
FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	male = {
		"models/pmc/pmc_3/pmc__02.mdl",
		"models/pmc/pmc_3/pmc__04.mdl",
		"models/pmc/pmc_3/pmc__05.mdl",
		"models/pmc/pmc_3/pmc__06.mdl",
		"models/pmc/pmc_3/pmc__07.mdl",
		"models/pmc/pmc_3/pmc__08.mdl",
		"models/pmc/pmc_3/pmc__09.mdl",
		"models/pmc/pmc_3/pmc__10.mdl",
		"models/pmc/pmc_3/pmc__11.mdl",
		"models/pmc/pmc_3/pmc__12.mdl",
		"models/pmc/pmc_3/pmc__13.mdl",
		"models/pmc/pmc_3/pmc__14.mdl"
	};
};

FACTION_GUARD = nexus.faction.Register(FACTION, "National Guard");