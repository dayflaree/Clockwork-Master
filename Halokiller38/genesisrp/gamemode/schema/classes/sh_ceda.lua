--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.color = Color(125, 150, 125, 255);
CLASS.factions = {FACTION_CEDA};
CLASS.isDefault = true;
CLASS.description = "A member of the Ukrainian Military.";
CLASS.defaultPhysDesc = "Wearing a Ukrainian Military uniform with a gasmask";

CLASS_CEDA = openAura.class:Register(CLASS, "Ukrainian Military");