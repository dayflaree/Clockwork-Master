
-----------------------------------------------------
local CLASS = Clockwork.class:New("Poison Headcrab");

CLASS.color = Color(200, 80, 80, 255);
CLASS.factions = {FACTION_ZOMBIE};
CLASS.model = "models/headcrabblack.mdl";
CLASS.isDefault = false;
CLASS.wagesName = "Supplies";
CLASS.description = "A beefy little creature, covered in leathery black skin and needle-thin hairs.";
CLASS.defaultPhysDesc = "A beefy little creature, covered in leathery black skin and needle-thin hairs.";
CLASS.morph = "headcrab_poison";

CLASS_FASTZOMBIE = CLASS:Register();