local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-branded Potato";
ITEM.uniqueID = "uu_potato";
ITEM.model = "models/bioshockinfinite/hext_potato.mdl";
ITEM.plural = "UU-branded Potatoes";
ITEM.cost = 25;
ITEM.weight = 0.15;
ITEM.health = 2;
ITEM.hunger = 15;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "One of the oddest UU Branded Products. A silicone shell filled with dehydrated potato. How do you even eat this?";

ITEM:Register();