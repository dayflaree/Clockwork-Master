--[[
Name: "sh_dexterity.lua".
Product: "Day One".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Dexterity";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "dex";
ATTRIBUTE.description = "Affects your overall dexterity, like how good you are with your hands.";
ATTRIBUTE.characterScreen = true;

ATB_DEXTERITY = blueprint.attribute.Register(ATTRIBUTE);