--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.color = Color(150, 125, 100, 255);
CLASS.factions = {FACTION_STALKER};
CLASS.isDefault = true;
CLASS.description = "A Stalker.";
CLASS.defaultPhysDesc = "Wearing a uniform with a gas mask";

CLASS_STALKER = openAura.class:Register(CLASS, "The Stalkers");