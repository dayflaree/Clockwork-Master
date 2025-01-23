--[[
Name: "sh_administrator.lua".
Product: "Half-Life 2".
--]]

local CLASS = {};

CLASS.color = Color(255, 200, 100, 255);
CLASS.wages = 50;
CLASS.factions = {FACTION_ADMIN};
CLASS.isDefault = true;
CLASS.wagesName = "Allowance";
CLASS.description = "A human Administrator advised by the Universal Union.";
CLASS.defaultPhysDesc = "Wearing a clean brown suit";

CLASS_ADMIN = resistance.class.Register(CLASS, "Administrator");