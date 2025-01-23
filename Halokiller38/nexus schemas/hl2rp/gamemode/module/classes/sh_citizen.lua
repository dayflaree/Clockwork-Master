--[[
Name: "sh_citizen.lua".
Product: "Half-Life 2".
--]]

local CLASS = {};

CLASS.color = Color(150, 125, 100, 255);
CLASS.factions = {FACTION_CITIZEN};
CLASS.isDefault = true;
CLASS.wagesName = "Supplies";
CLASS.description = "A regular human citizen enslaved by the Universal Union.";
CLASS.defaultPhysDesc = "Wearing dirty clothes.";

CLASS_CITIZEN = resistance.class.Register(CLASS, "Citizen");