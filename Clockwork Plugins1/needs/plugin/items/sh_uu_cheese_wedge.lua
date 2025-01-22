local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Cheese Wedge";
ITEM.uniqueID = "uu_cheese_wedge";
ITEM.cost = 12;
ITEM.model = "models/bioshockinfinite/pound_cheese.mdl";
ITEM.weight = 0.2;
ITEM.health = 1;
ITEM.hunger = 6;
ITEM.access = "u";
ITEM.business = false;
ITEM.category = "UU-Branded Items";
ITEM.description = "A slice of synthetic cheese. It is oddly oily and seems to fall apart in the hand. It smells fatty and greasy.";

ITEM:Register();