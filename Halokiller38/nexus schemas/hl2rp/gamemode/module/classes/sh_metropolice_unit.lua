--[[
Name: "sh_metropolice_unit.lua".
Product: "Half-Life 2".
--]]

local CLASS = {};

CLASS.color = Color(50, 100, 150, 255);
CLASS.wages = 20;
CLASS.factions = {FACTION_MPF};
CLASS.isDefault = true;
CLASS.wagesName = "Supplies";
CLASS.description = "A metropolice unit working as Civil Protection.";
CLASS.defaultPhysDesc = "Wearing a metrocop jacket with a radio";

CLASS_MPU = resistance.class.Register(CLASS, "Metropolice Unit");