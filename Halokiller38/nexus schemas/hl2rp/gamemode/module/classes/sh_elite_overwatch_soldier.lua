--[[
Name: "sh_elite_overwatch_soldier.lua".
Product: "Half-Life 2".
--]]

local CLASS = {};

CLASS.color = Color(150, 50, 50, 255);
CLASS.wages = 50;
CLASS.factions = {FACTION_OTA};
CLASS.wagesName = "Supplies";
CLASS.maleModel = "models/combine_super_soldier.mdl";
CLASS.description = "An elite transhuman Overwatch soldier produced by the Combine.";
CLASS.defaultPhysDesc = "Wearing shiny Overwatch gear";
CLASS_EOW = resistance.class.Register(CLASS, "Elite Overwatch Soldier");