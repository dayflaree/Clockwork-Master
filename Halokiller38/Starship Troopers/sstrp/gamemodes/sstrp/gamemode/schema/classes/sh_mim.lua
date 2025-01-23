--[[
Name: "sh_mim.lua".
Product: "Starship Troopers".
--]]

local CLASS = {};

CLASS.color = Color(50, 50, 150, 255);
CLASS.factions = {FACTION_MIM};
--CLASS.access = "%";
CLASS.isDefault = true;
CLASS.description = "Enlisted mobile infantry medic.";
CLASS.weapons = {"federation_morita", "nx_healstick"};

function CLASS:GetModel(player, defaultModel)
	local modelReplace = string.gsub(defaultModel, "i_", "i_m_");
	
	if (string.find(modelReplace, "_m_m_")) then
		return defaultModel;
	else
		return modelReplace;
	end;
end;

CLASS_MIM = nexus.class.Register(CLASS, "Mobile Infantry Medic");