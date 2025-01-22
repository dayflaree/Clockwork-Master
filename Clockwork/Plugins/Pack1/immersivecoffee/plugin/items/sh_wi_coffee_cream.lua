local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Coffee (Cream)";
ITEM.uniqueID = "wi_coffee_cream";
ITEM.model = "models/props_canteen/vacuumflask01b_cup.mdl";
ITEM.weight = 0.5;
ITEM.health = 5;
ITEM.thirst = 25;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.category = "UU-Branded Items";
ITEM.description = "A vacuum flask's cup, containing unsweetened but creamy coffee.";

ITEM:Register();