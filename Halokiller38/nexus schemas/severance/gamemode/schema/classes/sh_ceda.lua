--[[
Name: "sh_ceda.lua".
Product: "Severance".
--]]

local CLASS = {};

CLASS.color = Color(125, 150, 125, 255);
CLASS.factions = {FACTION_CEDA};
CLASS.isDefault = true;
CLASS.description = "A member of the Civil Emergency and Defense Agency.";
CLASS.defaultPhysDesc = "Wearing a dark grey uniform with a gas mask";

CLASS_CEDA = nexus.class.Register(CLASS, "C.E.D.A.");