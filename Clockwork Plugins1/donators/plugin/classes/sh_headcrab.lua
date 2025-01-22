
-----------------------------------------------------
local CLASS = Clockwork.class:New("Headcrab");

CLASS.color = Color(200, 80, 80, 255);
CLASS.factions = {FACTION_ZOMBIE};
CLASS.model = "models/headcrabclassic.mdl";
CLASS.isDefault = false;
CLASS.wagesName = "Supplies";
CLASS.description = "A headcrab.";
CLASS.defaultPhysDesc = "A curous little creature with many sharp teeth, and an under-cavity the size of a head.";
CLASS.morph = "headcrab";

-- not using HEADCRAB because that overwrites a global
CLASS_REGULARHEADCRAB = CLASS:Register();