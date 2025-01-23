--[[
Name: "sh_strength.lua".
Product: "eXperim3nt".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Radiation Resistance";
ATTRIBUTE.maximum = 1000;
ATTRIBUTE.uniqueID = "rad";
ATTRIBUTE.category = "Attributes";
ATTRIBUTE.description = "Affects every aspect of your life, the higher radiation, the more deadly.";
ATTRIBUTE.characterScreen = false;

ATB_RAD = nexus.attribute.Register(ATTRIBUTE);