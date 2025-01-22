local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Milk Jug";
ITEM.uniqueId = "uu_milk_jug";
ITEM.cost = 40;
ITEM.model = "models/props_junk/garbage_milkcarton001a.mdl";
ITEM.weight = 1;
ITEM.health = 3;
ITEM.thirst = 30;
ITEM.junk = "plastic_bottle";
ITEM.access = "u";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A jug filled with slightly chunky-tasting synthetic milk. Somewhat unappetizing, but a decent source of calcium..";

ITEM:Register();