--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = {};

CLASS.wages = 50;
CLASS.color = Color(150, 125, 100, 255);
CLASS.factions = {FACTION_STALKER};
CLASS.isDefault = true;
CLASS.wagesName = "Supplies";
CLASS.description = "A Loner with the mark of S.T.A.L.K.E.R";
CLASS.defaultPhysDesc = "Wearing tattered clothing";

CLASS_STALKER = openAura.class:Register(CLASS, "S.T.A.L.K.E.R");