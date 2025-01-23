local CLASS = {};

CLASS.color = Color(165, 155, 95, 255);
CLASS.factions = {FACTION_WEHR};
CLASS.isDefault = true;
CLASS.description = "A Wehrmacht Soldier.";
CLASS.defaultPhysDesc = "A Wehrmacht Soldier.";

CLASS_WEHR = blueprint.class.Register(CLASS, "Wehrmacht");