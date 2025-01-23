--[[
Name: "sh_endurance.lua".
Product: "Half-Life 2".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Endurance";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "end";
ATTRIBUTE.description = "Affects your overall endurance, e.g: how much pain you can take.";
ATTRIBUTE.characterScreen = true;

ATB_ENDURANCE = resistance.attribute.Register(ATTRIBUTE);