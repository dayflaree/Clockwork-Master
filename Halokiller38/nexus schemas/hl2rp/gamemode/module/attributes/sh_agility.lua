--[[
Name: "sh_agility.lua".
Product: "Half-Life 2".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Agility";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "agt";
ATTRIBUTE.description = "Affects your overall speed, e.g: how fast you run.";
ATTRIBUTE.characterScreen = true;

ATB_AGILITY = resistance.attribute.Register(ATTRIBUTE);