--[[
Name: "sh_mp.lua".
Product: "Starship Troopers".
--]]

local FACTION = {};

FACTION.singleGender = GENDER_MALE;
FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	male = {"models/civilsas.mdl"}
};

FACTION_MP1 = nexus.faction.Register(FACTION, "Military Police Marshall");