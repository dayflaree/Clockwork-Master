local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Coffee (Black)";
ITEM.uniqueID = "wi_coffee_black";
ITEM.cost = 30;
ITEM.model = "models/props_canteen/vacuumflask01b_cup.mdl";
ITEM.weight = 0.5;
ITEM.health = 5;
ITEM.thirst = 15;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.category = "UU-Branded Items";
ITEM.description = "A vacuum flask's cup, containing bold black coffee.";

ITEM:Register();