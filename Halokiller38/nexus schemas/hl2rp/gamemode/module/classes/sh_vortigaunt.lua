--[[
Name: "sh_vortigaunt.lua".
Product: "Half-Life 2".
--]]

local CLASS = {};

CLASS.color = Color(213, 111, 56, 255);
CLASS.factions = {FACTION_VORTIGAUNT};
CLASS.isDefault = true;
CLASS.wagesName = "Supplies";
CLASS.description = "An alien being called a Vortigaunt, who fled to Earth during the portal storms.";
CLASS.defaultPhysDesc = "Wearing dirty clothes.";

CLASS_VORTIGAUNT = resistance.class.Register(CLASS, "Vortigaunts");