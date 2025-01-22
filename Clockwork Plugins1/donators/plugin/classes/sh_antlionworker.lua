
-----------------------------------------------------
local CLASS = Clockwork.class:New("Antlion Worker")

CLASS.color = Color(255, 153, 0, 255);
CLASS.wages = false;
CLASS.factions = {FACTION_ANTLION};
CLASS.description = "Alien insect species, capable of spitting acid."
CLASS.defaultPhysDesc = "An insect creature with a bioluminescent body."
CLASS.morph = "ep2_antlion_worker";

CLASS_ANTLION_WORKER = CLASS:Register();