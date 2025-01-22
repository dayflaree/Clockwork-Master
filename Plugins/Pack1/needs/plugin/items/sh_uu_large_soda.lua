local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Large Soda";
ITEM.uniqueID = "uu_soda";
ITEM.cost = 60;
ITEM.model = "models/props_junk/garbage_plasticbottle003a.mdl";
ITEM.weight = 2;
ITEM.health = 4;
ITEM.thirst = 30;
ITEM.junk = "plastic_bottle";
ITEM.access = "u";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A larger bottle of soda adorning the UU Brand. Inside is a carbonated beverage tasting incredibly bitter, being little more than flavoured soda water.";

ITEM:Register();