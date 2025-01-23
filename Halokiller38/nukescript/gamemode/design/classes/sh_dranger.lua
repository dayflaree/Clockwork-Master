local CLASS = {};

CLASS.color = Color(165, 155, 95, 255);
CLASS.factions = {FACTION_DRANGER};
CLASS.isDefault = true;
CLASS.description = "A Desert Ranger.";
CLASS.defaultPhysDesc = "A Ranger looking badass.";

CLASS_DRANGER = blueprint.class.Register(CLASS, "Desert Rangers");