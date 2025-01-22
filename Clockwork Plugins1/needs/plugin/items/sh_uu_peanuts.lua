local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Peanuts";
ITEM.uniqueID = "uu_peanuts";
ITEM.cost = 20;
ITEM.model = "models/bioshockinfinite/rag_of_peanuts.mdl";
ITEM.weight = 0.1;
ITEM.health = 1;
ITEM.hunger = 10;
ITEM.access = "u";
ITEM.business = true;
ITEM.category = "UU-Branded Items";
ITEM.description = "A classic burlap bag adorning the UU Brand. While not salted, the peanuts inside do appear to be genuine.";

ITEM:Register();