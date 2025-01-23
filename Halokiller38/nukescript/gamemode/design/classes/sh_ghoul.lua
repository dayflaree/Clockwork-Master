local CLASS = {};

CLASS.color = Color(165, 155, 95, 255);
CLASS.factions = {FACTION_GHOUL};
CLASS.isDefault = true;
CLASS.description = "A ghoul.";
CLASS.defaultPhysDesc = "A ghoul wearing raggidy clothing.";

CLASS_GHOUL = blueprint.class.Register(CLASS, "Ghoul");