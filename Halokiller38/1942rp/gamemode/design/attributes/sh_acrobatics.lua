--[[
Name: "sh_acrobatics.lua".
Product: "Day One".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Acrobatics";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "acr";
ATTRIBUTE.description = "Affects the overall height at which you can jump.";
ATTRIBUTE.characterScreen = true;

ATB_ACROBATICS = blueprint.attribute.Register(ATTRIBUTE);