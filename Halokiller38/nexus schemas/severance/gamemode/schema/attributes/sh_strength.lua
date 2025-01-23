--[[
Name: "sh_strength.lua".
Product: "Severance".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Strength";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "str";
ATTRIBUTE.description = "Affects your overall strength, e.g: how hard you punch.";
ATTRIBUTE.characterScreen = true;

ATB_STRENGTH = nexus.attribute.Register(ATTRIBUTE);