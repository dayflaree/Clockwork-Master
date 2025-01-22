
-----------------------------------------------------
local CLASS = Clockwork.class:New("Poison Zombie");

CLASS.color = Color(200, 80, 80, 255);
CLASS.factions = {FACTION_ZOMBIE};
CLASS.model = "models/Zombie/Poison.mdl";
CLASS.isDefault = false;
CLASS.wagesName = "Supplies";
CLASS.description = "An unlucky citizen who met his fate by a headcrab from Xen.";
CLASS.defaultPhysDesc = "Wearing bloody clothes.";
CLASS.morph = "zombie_poison";

CLASS_POISONZOMBIE = CLASS:Register();