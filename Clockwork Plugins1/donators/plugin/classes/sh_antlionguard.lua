
-----------------------------------------------------
local CLASS = Clockwork.class:New("Antlion Guard")

CLASS.color = Color(255, 153, 0, 255);
CLASS.wages = false;
CLASS.factions = {FACTION_ANTLION};
CLASS.description = "A bulky, armored, wingless Antlion Guard."
CLASS.defaultPhysDesc = "An insect creature with chitinous armor and a large carapace."
CLASS.morph = "antlion_guard";

CLASS_ANTLIONGUARD = CLASS:Register();