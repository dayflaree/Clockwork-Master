--[[
Name: "sh_agility.lua".
Product: "Severance".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Agility";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "agt";
ATTRIBUTE.description = "Affects your overall speed, e.g: how fast you run.";
ATTRIBUTE.characterScreen = true;

ATB_AGILITY = nexus.attribute.Register(ATTRIBUTE);