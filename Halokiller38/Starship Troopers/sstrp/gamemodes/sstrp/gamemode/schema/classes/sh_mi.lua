--[[
Name: "sh_mi.lua".
Product: "Starship Troopers".
--]]

local CLASS = {};

CLASS.color = Color(0, 0, 150, 255);
CLASS.factions = {FACTION_MI};
--CLASS.access = "#";
CLASS.isDefault = true;
CLASS.description = "Enlisted mobile infantry.";
CLASS.weapons = {"federation_morita"};

CLASS_MI = nexus.class.Register(CLASS, "Mobile Infantry");