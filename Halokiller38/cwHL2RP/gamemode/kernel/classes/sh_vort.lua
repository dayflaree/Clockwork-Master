--[[
	Free Clockwork!
--]]

local CLASS = {};
	CLASS.wages = 0;
	CLASS.color = Color(0, 170, 20, 255);
	CLASS.factions = {FACTION_VORT};
	CLASS.isDefault = true;
	CLASS.wagesName = "Supplies";
	CLASS.defaultPhysDesc = "A slimey alien";
CLASS_VORT = Clockwork.class:Register(CLASS, "Vortigaunt");