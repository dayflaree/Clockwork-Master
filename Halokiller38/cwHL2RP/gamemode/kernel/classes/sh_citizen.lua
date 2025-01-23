--[[
	Free Clockwork!
--]]

local CLASS = {};
	CLASS.wages = 0;
	CLASS.color = Color(150, 125, 100, 255);
	CLASS.factions = {FACTION_CITIZEN};
	CLASS.isDefault = true;
	CLASS.wagesName = "Supplies";
	CLASS.description = "Just a random guy.";
	CLASS.defaultPhysDesc = "Wearing tattered clothing";
CLASS_CITIZEN = Clockwork.class:Register(CLASS, "Citizen");