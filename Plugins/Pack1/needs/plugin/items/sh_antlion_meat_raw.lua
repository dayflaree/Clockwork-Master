local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Raw Antlion Meat";
ITEM.uniqueID = "antlion_meat_raw";
ITEM.hunger = 20;
ITEM.damage = 5;
ITEM.model = "models/gibs/xenians/mgib_01.mdl";
ITEM.weight = 0.8;
ITEM.access = "Mv";
ITEM.business = false;
ITEM.description = "A hunk of raw antlion flesh. It would be wise to cook it first, lest you contract some kind of disease.";

ITEM:Register();