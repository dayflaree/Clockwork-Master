--[[
Name: "sh_agility.lua".
Product: "Day One".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Agility";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "agt";
ATTRIBUTE.description = "Affects your overall speed, like how fast you run.";
ATTRIBUTE.characterScreen = true;

ATB_AGILITY = blueprint.attribute.Register(ATTRIBUTE);