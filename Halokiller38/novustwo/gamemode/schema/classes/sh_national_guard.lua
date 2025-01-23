--[[
Name: "sh_national_guard.lua".
Product: "Novus Two".
--]]

local CLASS = {};

CLASS.color = Color(50, 200, 175, 255);
CLASS.factions = {FACTION_GUARD};
CLASS.isDefault = true;
CLASS.description = "A member of the last standing armed forces.";
CLASS.defaultPhysDesc = "Wearing military gear and equipment";

CLASS_GUARD = nexus.class.Register(CLASS, "National Guard");