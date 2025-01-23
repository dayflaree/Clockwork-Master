local CLASS = {};

CLASS.color = Color(165, 155, 95, 255);
CLASS.factions = {FACTION_NCR};
CLASS.isDefault = true;
CLASS.description = "A surviving member of the armed forces.";
CLASS.defaultPhysDesc = "Wearing military gear and equipment";

CLASS_NCR = blueprint.class.Register(CLASS, "New California Republic");