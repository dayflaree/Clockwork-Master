--[[
Name: "sh_fleet.lua".
Product: "Starship Troopers".
--]]

local CLASS = {};

CLASS.color = Color(0, 0, 150, 255);
CLASS.factions = {FACTION_FLEET};
--CLASS.access = "@";
CLASS.isDefault = true;
CLASS.description = "Federation Fleet.";
CLASS.weapons = {"federation_morita"};

CLASS_FLEET = nexus.class.Register(CLASS, "Federation Fleet");