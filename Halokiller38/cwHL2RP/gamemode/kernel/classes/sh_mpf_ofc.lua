--[[
	Free Clockwork!
--]]

local CLASS = {};

CLASS.color = Color(50, 100, 150, 255);
CLASS.wages = 50;
CLASS.factions = {FACTION_MPF};
CLASS.maleModel = "models/policetrench.mdl";
CLASS.wagesName = "Supplies";
CLASS.description = "A Metropolice Unit";
CLASS.defaultPhysDesc = "Wearing a metrocop jacket with a radio";

CLASS_MPF_OFC = Clockwork.class:Register(CLASS, "Metropolice Force Officer");