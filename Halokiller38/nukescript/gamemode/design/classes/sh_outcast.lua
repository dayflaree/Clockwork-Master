local CLASS = {};

CLASS.color = Color(128, 0, 0, 255);
CLASS.factions = {FACTION_OUTCAST};
CLASS.isDefault = true;
CLASS.description = "A young person wearing red power armor.";
CLASS.defaultPhysDesc = "A young person with red power armor and an old laser rifle.";

CLASS_OUTCAST = blueprint.class.Register(CLASS, "Brootherhood of Steel Outcast");