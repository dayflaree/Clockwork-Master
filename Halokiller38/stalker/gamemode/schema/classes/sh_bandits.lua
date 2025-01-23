--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.color = Color(0, 0, 0, 255);
CLASS.wages = 150;
CLASS.factions = {FACTION_BANDIT};
CLASS.isDefault = true;
CLASS.wagesName = "RU";
CLASS.description = "A Bandit Soldier.";
CLASS.defaultPhysDesc = "A Heavy Builded man with a bandit symbol on his chest.";

CLASS_BANDIT = openAura.class:Register(CLASS, "The Bandits");