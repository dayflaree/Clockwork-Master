--[[
Name: "sh_dexterity.lua".
Product: "Novus Two".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Dexterity";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "dex";
ATTRIBUTE.description = "Affects your overall dexterity, like how fast you can tie.";
ATTRIBUTE.characterScreen = true;

ATB_DEXTERITY = nexus.attribute.Register(ATTRIBUTE);