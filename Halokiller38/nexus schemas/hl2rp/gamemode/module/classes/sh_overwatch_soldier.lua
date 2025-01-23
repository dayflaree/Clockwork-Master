--[[
Name: "sh_overwatch_soldier.lua".
Product: "Half-Life 2".
--]]

local CLASS = {};

CLASS.color = Color(150, 50, 50, 255);
CLASS.wages = 40;
CLASS.factions = {FACTION_OTA};
CLASS.wagesName = "Supplies";
CLASS.description = "A transhuman Overwatch soldier produced by the Combine.";
CLASS.defaultPhysDesc = "Wearing dirty Overwatch gear";

CLASS_OWS = resistance.class.Register(CLASS, "Overwatch Soldier");