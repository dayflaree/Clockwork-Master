local CLASS = {};

CLASS.color = Color(165, 155, 95, 255);
CLASS.factions = {FACTION_RAIDER};
CLASS.isDefault = true;
CLASS.description = "A Raider, they'll take your shit.";
CLASS.defaultPhysDesc = "A Raider with Raider Armor";

CLASS_RAIDER = blueprint.class.Register(CLASS, "Raider");