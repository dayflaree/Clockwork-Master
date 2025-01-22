
-----------------------------------------------------
local CLASS = Clockwork.class:New("Aliengrunt");
	CLASS.color = Color(200, 80, 80, 255);
	CLASS.factions = {FACTION_ALIENGRUNT};
	CLASS.isDefault = true;
	CLASS.wagesName = "Supplies";
	CLASS.description = "A bulky and heavy Xenian creature with three arms.";
	CLASS.defaultPhysDesc = "A bulky and heavy Xenian creature with three arms.";
CLASS_ALIENGRUNT = CLASS:Register();