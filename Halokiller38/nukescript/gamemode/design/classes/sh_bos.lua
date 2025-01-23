local CLASS = {};

CLASS.color = Color(128, 0, 0, 255);
CLASS.factions = {FACTION_BOS};
CLASS.isDefault = true;
CLASS.description = "A young person wearing power armor.";
CLASS.defaultPhysDesc = "A young person with power armor and an laser rifle.";

CLASS_BOS = blueprint.class.Register(CLASS, "Brootherhood of Steel");