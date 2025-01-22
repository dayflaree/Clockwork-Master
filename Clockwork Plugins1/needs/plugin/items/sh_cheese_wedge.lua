local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Cheese Wedge";
ITEM.uniqueID = "cheese_wedge";
ITEM.model = "models/bioshockinfinite/round_cheese.mdl";
ITEM.description = "A slice of mature cheese. It is soft and malleable, smelling distinctly of Monterey Jack or something similar. It is a good source of calcium.";
ITEM.weight = 0.2;
ITEM.hunger = 8;
ITEM.health = 1;
ITEM.cost = 5;
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnValue = 11;
ITEM.spawnType = "consumable";

ITEM:Register();