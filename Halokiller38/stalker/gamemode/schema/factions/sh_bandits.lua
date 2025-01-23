--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.material = "stalker/factions/bandit";
FACTION.models = {
	female = {
	"models/stalkertnb/bandit_female1.mdl",
	"models/stalkertnb/bandit_female2.mdl",
	"models/stalkertnb/bandit_female3.mdl",
	"models/stalkertnb/bandit_female4.mdl",
	"models/stalkertnb/bandit_female5.mdl",
	"models/stalkertnb/bandit_female7.mdl"
	},
	male = {
	"models/stalkertnb/bandit_male1.mdl",
	"models/stalkertnb/bandit_male2.mdl",
	"models/stalkertnb/bandit_male3.mdl",
	"models/stalkertnb/bandit_male4.mdl",
	"models/stalkertnb/bandit_male5.mdl",
	};
};

FACTION_BANDIT = openAura.faction:Register(FACTION, "The Bandits");