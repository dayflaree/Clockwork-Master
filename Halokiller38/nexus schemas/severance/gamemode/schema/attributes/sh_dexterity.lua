--[[
Name: "sh_dexterity.lua".
Product: "Severance".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Dexterity";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "dex";
ATTRIBUTE.description = "Affects your overall dexterity, e.g: how fast you can tie/untie.";
ATTRIBUTE.characterScreen = true;

ATB_DEXTERITY = nexus.attribute.Register(ATTRIBUTE);