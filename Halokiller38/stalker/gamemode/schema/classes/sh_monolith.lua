--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.color = Color(105, 105, 105, 255);
CLASS.wages = 250;
CLASS.factions = {FACTION_MONOLITH};
CLASS.isDefault = true;
CLASS.wagesName = "RU";
CLASS.description = "A Monolith soldier.";
CLASS.defaultPhysDesc = "A Heavy Builded man with a Monolith symbol on his chest.";

CLASS_MONOLITH = openAura.class:Register(CLASS, "Monolith");