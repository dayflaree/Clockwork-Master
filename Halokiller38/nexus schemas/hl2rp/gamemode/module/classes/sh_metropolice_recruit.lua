--[[
Name: "sh_metropolice_recruit.lua".
Product: "Half-Life 2".
--]]

local CLASS = {};

CLASS.color = Color(50, 100, 150, 255);
CLASS.wages = 10;
CLASS.factions = {FACTION_MPF};
CLASS.wagesName = "Supplies";
CLASS.description = "A metropolice recruit working as Civil Protection.";
CLASS.defaultPhysDesc = "Wearing a metrocop jacket with a radio";

CLASS_MPR = resistance.class.Register(CLASS, "Metropolice Recruit");