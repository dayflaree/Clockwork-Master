local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Orange";
ITEM.uniqueID = "uu_orange";
ITEM.cost = 30;
ITEM.model = "models/bioshockinfinite/hext_orange.mdl";
ITEM.weight = 0.25;
ITEM.health = 3;
ITEM.hunger = 15;
ITEM.thirst = 5;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A synthetic orange fruit, consisting of a thick orange silicone shell, filled with a slightly paler orange gel on the interior. Biting into the gel would taste somewhat reminiscent of orange candy, but saccharin sweet.";

ITEM:Register(ITEM);