--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.color = Color(164, 0, 4, 255);
CLASS.wages = 250;
CLASS.factions = {FACTION_DUTY};
CLASS.isDefault = true;
CLASS.wagesName = "RU";
CLASS.description = "A duty soldier.";
CLASS.defaultPhysDesc = "A Heavy Builded man with a Duty Symbol on his chest.";

CLASS_DUTY = openAura.class:Register(CLASS, "Duty");