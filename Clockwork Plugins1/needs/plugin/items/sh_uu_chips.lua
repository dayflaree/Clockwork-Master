local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Chips";
ITEM.uniqueID = "uu_chips";
ITEM.cost = 20;
ITEM.model = "models/bioshockinfinite/bag_of_hhips.mdl";
ITEM.weight = 0.3;
ITEM.health = 1;
ITEM.hunger = 10;
ITEM.access = "u";
ITEM.business = false;
ITEM.category = "UU-Branded Items";
ITEM.description = "A small bag adorning the UU Brand, filled with synthetic potato chips. They're not flavoured at all beyond MSG, and seem somewhat soggy.";

ITEM:Register();