
-----------------------------------------------------
local CLASS = Clockwork.class:New("Bird")

CLASS.color = Color(120, 250, 20, 255);
CLASS.wages = false;
CLASS.factions = {FACTION_BIRD};
CLASS.description = "Flying feathered things."
CLASS.defaultPhysDesc = "An annoying, loud bird with dirty feathers."

CLASS_BIRD = CLASS:Register();