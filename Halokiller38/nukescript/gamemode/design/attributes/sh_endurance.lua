--[[
Name: "sh_endurance.lua".
Product: "Day One".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Endurance";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "end";
ATTRIBUTE.description = "Affects your overall endurance, like how much pain you can take.";
ATTRIBUTE.characterScreen = true;

ATB_ENDURANCE = blueprint.attribute.Register(ATTRIBUTE);