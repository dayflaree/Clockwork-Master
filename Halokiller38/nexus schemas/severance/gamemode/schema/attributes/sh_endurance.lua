--[[
Name: "sh_endurance.lua".
Product: "Severance".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Endurance";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "end";
ATTRIBUTE.description = "Affects your overall endurance, e.g: how much pain you can take.";
ATTRIBUTE.characterScreen = true;

ATB_ENDURANCE = nexus.attribute.Register(ATTRIBUTE);