local CLASS = {};

CLASS.color = Color(165, 155, 95, 255);
CLASS.factions = {FACTION_RANGER};
CLASS.isDefault = true;
CLASS.description = "A Ranger for the NCR.";
CLASS.defaultPhysDesc = "A Ranger looking badass.";

CLASS_RANGER = blueprint.class.Register(CLASS, "New California Republic Ranger");