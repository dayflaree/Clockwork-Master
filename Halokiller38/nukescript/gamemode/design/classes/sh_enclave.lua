local CLASS = {};

CLASS.color = Color(0, 255, 0, 255);
CLASS.factions = {FACTION_ENCLAVE};
CLASS.isDefault = true;
CLASS.description = "A young person wearing power armor.";
CLASS.defaultPhysDesc = "A young person with power armor and a plasma rifle.";

CLASS_ENCLAVE = blueprint.class.Register(CLASS, "Enclave");