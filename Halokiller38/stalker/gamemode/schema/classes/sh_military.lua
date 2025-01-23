--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.color = Color(0, 102, 51, 255);
CLASS.wages = 300;
CLASS.factions = {FACTION_MILITARY};
CLASS.isDefault = true;
CLASS.wagesName = "RU";
CLASS.description = "A military soldier.";
CLASS.defaultPhysDesc = "A Heavy Builded man with a UKM symbol on his chest.";

CLASS_MILITARY = openAura.class:Register(CLASS, "The Military");