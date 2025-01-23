--[[
	Free Clockwork!
--]]

local CLASS = {};

CLASS.color = Color(50, 100, 150, 255);
CLASS.wages = 25;
CLASS.factions = {FACTION_MPF};
CLASS.wagesName = "Supplies";
CLASS.description = "A Metropolice Unit";
CLASS.defaultPhysDesc = "Wearing a metrocop jacket with a radio";

CLASS_MPF_UNIT = Clockwork.class:Register(CLASS, "Metropolice Force Unit");