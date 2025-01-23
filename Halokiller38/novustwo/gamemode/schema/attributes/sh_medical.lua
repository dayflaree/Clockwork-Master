
--[[
Name: "sh_medical.lua".
Product: "Novus Two".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Medical";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "med";
ATTRIBUTE.description = "Affects your overall medical skills, like how much you can heal.";
ATTRIBUTE.characterScreen = true;

ATB_MEDICAL = nexus.attribute.Register(ATTRIBUTE);