--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.color = Color(51, 102, 153, 255);
CLASS.factions = {FACTION_NAZI};
CLASS.isDefault = true;
CLASS.description = "A member of the Fourth Reich.";
CLASS.defaultPhysDesc = "Wearing a dark grey uniform with a gas mask";

CLASS_NAZI = openAura.class:Register(CLASS, "4th Reich");