--[[
Name: "sh_civilian_insurgency.lua".
Product: "Novus Two".
--]]

local CLASS = {};

CLASS.color = Color(100, 180, 50, 255);
CLASS.factions = {FACTION_INSURGENCY};
CLASS.isDefault = true;
CLASS.description = "A member of the freedom fighting insurgency.";
CLASS.defaultPhysDesc = "Wearing dirty camouflage and a satchel";

CLASS_INSURGENCY = nexus.class.Register(CLASS, "Civilian Insurgency");