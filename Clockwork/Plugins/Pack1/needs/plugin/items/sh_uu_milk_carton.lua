local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Milk Carton";
ITEM.uniqueID = "uu_milk_carton";
ITEM.cost = 25;
ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl";
ITEM.weight = 0.8;
ITEM.access = "u";
ITEM.health = 3;
ITEM.thirst = 20;
ITEM.junk = "empty_milk_carton";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A carton filled with slightly chunky-tasting synthetic milk. Somewhat unappetizing, but a decent source of calcium.";

ITEM:Register();