local CLASS = {};

CLASS.color = Color(165, 155, 95, 255);
CLASS.factions = {FACTION_ALIENS};
CLASS.isDefault = true;
CLASS.description = "A survivor of the world's most catastrophic epidemic.";
CLASS.defaultPhysDesc = "Wearing dirty clothes and a small satchel";

CLASS_ALIENS = blueprint.class.Register(CLASS, "Aliens");