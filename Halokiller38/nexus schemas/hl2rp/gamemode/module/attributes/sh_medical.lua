--[[
Name: "sh_medical.lua".
Product: "Half-Life 2".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Medical";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "med";
ATTRIBUTE.description = "Affects your overall medical skills, e.g: health gained from vials and kits.";
ATTRIBUTE.characterScreen = true;

ATB_MEDICAL = resistance.attribute.Register(ATTRIBUTE);