--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.color = Color(234, 182, 26, 255);
CLASS.wages = 250;
CLASS.factions = {FACTION_FREEDOM};
CLASS.isDefault = true;
CLASS.wagesName = "RU";
CLASS.description = "A Freedom Soldier";
CLASS.defaultPhysDesc = "A Heavy Builded man with a freedom symbol on his chest.";

CLASS_FREEDOM = openAura.class:Register(CLASS, "Freedom");