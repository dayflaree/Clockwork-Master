local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Coffee";
ITEM.uniqueID = "coffee";
ITEM.model = "models/bioshockinfinite/coffee_mug_closed.mdl";
ITEM.description = "A small pre-sealed can of instant dark-roast coffee. It appears cheap, but on the bright side, it's highly caffeinated.";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.weight = 0.5;
ITEM.thirst = 25;
ITEM.health = 4;
ITEM.cost = 7;
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnValue = 33;
ITEM.spawnType = "consumable";

ITEM:Register();