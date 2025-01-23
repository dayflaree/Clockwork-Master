--[[
Name: "sh_stamina.lua".
Product: "Day One".
--]]

local ATTRIBUTE = {};

ATTRIBUTE.name = "Stamina";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "stam";
ATTRIBUTE.description = "Affects your overall stamina, like how long you can run for.";
ATTRIBUTE.characterScreen = true;

ATB_STAMINA = blueprint.attribute.Register(ATTRIBUTE);