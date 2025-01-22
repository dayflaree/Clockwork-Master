
-----------------------------------------------------
local CLASS = Clockwork.class:New("Fast Headcrab");

CLASS.color = Color(200, 80, 80, 255);
CLASS.factions = {FACTION_ZOMBIE};
CLASS.model = "models/headcrab.mdl";
CLASS.isDefault = false;
CLASS.wagesName = "Supplies";
CLASS.description = "A bony little creature, with many sharp teeth and startling agility.";
CLASS.defaultPhysDesc = "A bony little creature, with many sharp teeth and startling agility.";
CLASS.morph = "headcrab_fast";

CLASS_FASTHEADCRAB = CLASS:Register();