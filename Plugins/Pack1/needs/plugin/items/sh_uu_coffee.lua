local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Coffee";
ITEM.uniqueID = "uu_coffee";
ITEM.cost = 15;
ITEM.model = "models/bioshockinfinite/xoffee_mug_closed.mdl";
ITEM.weight = 0.5;
ITEM.health = 3;
ITEM.thirst = 10;
ITEM.access = "u";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A small can of instant coffee. It tastes smooth and creamy. Arguments still stand over which of the two UU Branded coffees is best.";

ITEM:Register();