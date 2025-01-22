
-----------------------------------------------------
local CLASS = Clockwork.class:New("Fast Zombie");

CLASS.color = Color(200, 80, 80, 255);
CLASS.factions = {FACTION_ZOMBIE};
CLASS.model = "models/Zombie/Fast.mdl";
CLASS.isDefault = false;
CLASS.wagesName = "Supplies";
CLASS.description = "An unlucky citizen who met his fate by a headcrab from Xen.";
CLASS.defaultPhysDesc = "Wearing bloody clothes.";
CLASS.morph = "zombie_fast";

CLASS_FASTZOMBIE = CLASS:Register();