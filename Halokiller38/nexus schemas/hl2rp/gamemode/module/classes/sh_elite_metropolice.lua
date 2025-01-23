--[[
Name: "sh_elite_metropolice.lua".
Product: "Half-Life 2".
--]]

local CLASS = {};

CLASS.color = Color(50, 100, 150, 255);
CLASS.wages = 30;
CLASS.factions = {FACTION_MPF};
CLASS.wagesName = "Supplies";
CLASS.maleModel = "models/leet_police2.mdl";
CLASS.description = "An elite metropolice unit working as Civil Protection.";
CLASS.defaultPhysDesc = "Wearing a metrocop jacket with a radio";

CLASS_EMP = resistance.class.Register(CLASS, "Elite Metropolice");