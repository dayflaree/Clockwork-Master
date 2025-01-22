local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Coffee Creamer";
ITEM.uniqueID = "wi_cream";
ITEM.model = "models/gibs/props_canteen/vm_snack23.mdl";
ITEM.weight = 0.1;
ITEM.health = 1;
ITEM.thirst = 5;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.category = "UU-Branded Items";
ITEM.description = "A small carton of liquid coffee creamer, perfect for adding tocoffee.";

ITEM:Register();