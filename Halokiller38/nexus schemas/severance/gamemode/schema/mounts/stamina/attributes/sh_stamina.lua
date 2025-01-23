--[[
Name: "sh_stamina.lua".
Product: "Severance".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Stamina";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "stam";
ATTRIBUTE.description = "Affects your overall stamina, e.g: how long you can run for.";
ATTRIBUTE.characterScreen = true;

ATB_STAMINA = nexus.attribute.Register(ATTRIBUTE);