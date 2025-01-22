local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Wheat Cereal";
ITEM.uniqueID = "uu_cereal";
ITEM.cost = 60;
ITEM.model = "models/bioshockinfinite/hext_cereal_box_cornflakes.mdl";
ITEM.weight = 2;
ITEM.health = 3;
ITEM.hunger = 30;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A box of still sealed cereal, adorning the UU Brand. The cereals are clearly produced cheaply, and seem stale to the taste.";

ITEM:Register();