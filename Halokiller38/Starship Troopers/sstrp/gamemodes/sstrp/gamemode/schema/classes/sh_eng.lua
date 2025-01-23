--[[
Name: "sh_eng.lua".
Product: "Starship Troopers".
--]]

local CLASS = {};

CLASS.color = Color(0, 0, 150, 255);
CLASS.factions = {FACTION_ENG};
--CLASS.access = "!";
CLASS.isDefault = true;
CLASS.description = "Mobile Infantry Engineer.";
CLASS.weapons = {"federation_morita", "federation_shotgun", "weapon_physgun"};

CLASS_ENG = nexus.class.Register(CLASS, "Mobile Infantry Engineer");