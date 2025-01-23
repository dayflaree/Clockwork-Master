--[[
Name: "sh_recruit.lua".
Product: "Starship Troopers".
--]]

local CLASS = {};

CLASS.color = Color(150, 100, 50, 255);
CLASS.factions = {FACTION_RECRUIT};
CLASS.isDefault = true;
CLASS.description = "A recruit waiting for training.";

CLASS_RECRUIT = nexus.class.Register(CLASS, "Recruit");