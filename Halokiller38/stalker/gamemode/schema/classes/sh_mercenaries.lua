--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.color = Color(113, 58, 120, 255);
CLASS.wages = 250;
CLASS.factions = {FACTION_MERC};
CLASS.isDefault = true;
CLASS.wagesName = "RU";
CLASS.description = "A heavy Mercenarie soldier.";
CLASS.defaultPhysDesc = "A Heavy Builded man with a merc symbol on his chest.";

CLASS_MERC = openAura.class:Register(CLASS, "The Mercenaries");