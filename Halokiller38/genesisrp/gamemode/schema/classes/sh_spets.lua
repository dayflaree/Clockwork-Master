--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.color = Color(180, 0, 0, 255);
CLASS.factions = {FACTION_SPETS};
CLASS.isDefault = true;
CLASS.description = "A member of the Special Ops known as Spetsnaz.";
CLASS.defaultPhysDesc = "Wearing a Spetsnaz uniform with a gasmask";

CLASS_SPETS = openAura.class:Register(CLASS, "Spetsnaz");