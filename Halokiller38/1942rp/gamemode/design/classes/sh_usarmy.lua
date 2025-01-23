local CLASS = {};

CLASS.color = Color(165, 155, 95, 255);
CLASS.factions = {FACTION_US};
CLASS.isDefault = true;
CLASS.description = "A USA Soldier.";
CLASS.defaultPhysDesc = "A USA Soldier.";

CLASS_US = blueprint.class.Register(CLASS, "The United States of America");