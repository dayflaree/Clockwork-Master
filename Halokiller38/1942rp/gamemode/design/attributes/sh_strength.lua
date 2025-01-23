--[[
Name: "sh_strength.lua".
Product: "Day One".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Strength";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "str";
ATTRIBUTE.description = "Affects your overall strength, like how hard you can punch.";
ATTRIBUTE.characterScreen = true;

ATB_STRENGTH = blueprint.attribute.Register(ATTRIBUTE);