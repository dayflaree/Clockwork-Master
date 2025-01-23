--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.color = Color(150, 125, 100, 255);
CLASS.factions = {FACTION_CIVILIAN};
CLASS.isDefault = true;
CLASS.description = "A person that's returned to Chernobyl after the incident.";
CLASS.defaultPhysDesc = "Wearing a dirty mask.";

CLASS_SURVIVOR = openAura.class:Register(CLASS, "Children of Chernobyl");