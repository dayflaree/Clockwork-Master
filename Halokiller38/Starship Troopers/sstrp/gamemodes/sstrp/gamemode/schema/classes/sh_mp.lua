--[[
Name: "sh_mp.lua".
Product: "Starship Troopers".
--]]

local CLASS = {};

CLASS.color = Color(0, 0, 190, 255);
CLASS.factions = {FACTION_MP1};
--CLASS.access = "X";
CLASS.isDefault = true;
CLASS.description = "QuarterMaster.";
CLASS.weapons = {"nx_morita", "nx_shotgun", "weapon_stunstick"};

function CLASS:GetModel(player, defaultModel)
	return "models/modile.mdl";
end;

CLASS_MP1 = nexus.class.Register(CLASS, "Military Police Marshall");