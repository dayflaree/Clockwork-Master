local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Cheese Wheel";
ITEM.uniqueID = "cheese_wheel";
ITEM.model = "models/bioshockinfinite/round_cheese.mdl";
ITEM.description = "A large wheel of mature cheese. It is soft and malleable, smelling distinctly of Monterey Jack or something similar. It is a good source of calcium.";
ITEM.weight = 1;
ITEM.hunger = 40;
ITEM.health = 5;
ITEM.cost = 16;
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnValue = 4;
ITEM.spawnType = "consumable";

ITEM:Register();