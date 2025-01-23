--[[
	Free Clockwork!
--]]

local CLASS = {};

CLASS.color = Color(50, 100, 150, 255);
CLASS.wages = 150;
CLASS.factions = {FACTION_MPF};
CLASS.maleModel = "models/sect_police2.mdl";
CLASS.wagesName = "Supplies";
CLASS.description = "A Metropolice Unit";
CLASS.defaultPhysDesc = "Wearing a metrocop jacket with a radio";

CLASS_MPF_SEC = Clockwork.class:Register(CLASS, "Sectorial Commander");