--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.color = Color(178, 34, 34, 255);
CLASS.factions = {FACTION_COMMUNIST};
CLASS.isDefault = true;
CLASS.description = "A member of the Red Army.";
CLASS.defaultPhysDesc = "Wearing a dark grey uniform with a gas mask";

CLASS_COMMUNIST = openAura.class:Register(CLASS, "The Communists");