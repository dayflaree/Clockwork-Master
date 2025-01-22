local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Cheese Wheel";
ITEM.uniqueID = "uu_cheese_wheel";
ITEM.cost = 60;
ITEM.model = "models/bioshockinfinite/pound_cheese.mdl";
ITEM.weight = 1;
ITEM.health = 3;
ITEM.hunger = 30;
ITEM.access = "u";
ITEM.business = true;
ITEM.category = "UU-Branded Items";
ITEM.description = "A large wheel of synthetic cheese. It is oddly oily, and seems to fall apart in the hand. It smells fatty and greasy.";

ITEM:Register();