--[[
Name: "sh_wastelander.lua".
Product: "Novus Two".
--]]

local CLASS = {};

CLASS.color = Color(165, 155, 95, 255);
CLASS.factions = {FACTION_WASTELANDER};
CLASS.isDefault = true;
CLASS.description = "A survivor of the world's most catastrophic epidemic.";
CLASS.defaultPhysDesc = "Wearing dirty clothes and a small satchel";

CLASS_WASTELANDER = nexus.class.Register(CLASS, "Wastelander");