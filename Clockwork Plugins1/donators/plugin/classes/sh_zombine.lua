
-----------------------------------------------------
local CLASS = Clockwork.class:New("Zombine");

CLASS.color = Color(200, 80, 80, 255);
CLASS.factions = {FACTION_ZOMBIE};
CLASS.model = "models/zombie/zombie_soldier.mdl";
CLASS.isDefault = false;
CLASS.wagesName = "Supplies";
CLASS.description = "An unlucky transhuman soldier who met his fate by a headcrab from Xen.";
CLASS.defaultPhysDesc = "Wearing bloody clothes.";
CLASS.morph = "ep1_zombine";

CLASS_ZOMBINE = CLASS:Register();