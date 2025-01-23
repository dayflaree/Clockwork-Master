--[[
	Free Clockwork!
--]]

local CLASS = {};

CLASS.color = Color(50, 100, 150, 255);
CLASS.wages = 60;
CLASS.factions = {FACTION_MPF};
CLASS.maleModel = "models/eliteshockcp.mdl";
CLASS.wagesName = "Supplies";
CLASS.description = "A Metropolice Unit";
CLASS.defaultPhysDesc = "Wearing a metrocop jacket with a radio";

CLASS_MPF_DVL = Clockwork.class:Register(CLASS, "Divison Leader");