--[[
Name: "sh_metropolice_scanner.lua".
Product: "Half-Life 2".
--]]

local CLASS = {};

CLASS.color = Color(50, 100, 150, 255);
CLASS.factions = {FACTION_MPF};
CLASS.description = "A metropolice scanner, it utilises Combine technology.";
CLASS.defaultPhysDesc = "Making beeping sounds";

CLASS_MPS = resistance.class.Register(CLASS, "Metropolice Scanner");