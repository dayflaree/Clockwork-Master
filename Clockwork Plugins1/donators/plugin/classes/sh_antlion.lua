
-----------------------------------------------------
local CLASS = Clockwork.class:New("Antlion")

CLASS.color = Color(255, 153, 0, 255);
CLASS.wages = false;
CLASS.factions = {FACTION_ANTLION};
CLASS.description = "Alien insect species, able to fly short distances"
CLASS.defaultPhysDesc = "An insect creature with greenish skin and wings."
CLASS.morph = "antlion";

CLASS_ANTLION = CLASS:Register();