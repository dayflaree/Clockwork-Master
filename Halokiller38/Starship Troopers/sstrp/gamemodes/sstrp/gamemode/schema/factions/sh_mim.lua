--[[
Name: "sh_mim.lua".
Product: "Starship Troopers".
--]]

local FACTION = {};

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	female = {
		"models/mobileinfantry/fmi_m_01.mdl",
		"models/mobileinfantry/fmi_m_02.mdl",
		"models/mobileinfantry/fmi_m_03.mdl",
		"models/mobileinfantry/fmi_m_04.mdl",
		"models/mobileinfantry/fmi_m_06.mdl",
		"models/mobileinfantry/fmi_m_07.mdl"
	},
	
	male = {
		"models/mobileinfantry/mi_m_01.mdl",
		"models/mobileinfantry/mi_m_02.mdl",
		"models/mobileinfantry/mi_m_03.mdl",
		"models/mobileinfantry/mi_m_04.mdl",
		"models/mobileinfantry/mi_m_05.mdl",
		"models/mobileinfantry/mi_m_06.mdl",
		"models/mobileinfantry/mi_m_07.mdl",
		"models/mobileinfantry/mi_m_08.mdl",
		"models/mobileinfantry/mi_m_09.mdl"
	}
};

FACTION_MIM = nexus.faction.Register(FACTION, "Mobile Infantry Medic");