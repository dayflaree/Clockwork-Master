local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Apple";
ITEM.uniqueID = "uu_apple";
ITEM.cost = 30;
ITEM.model = "models/bioshockinfinite/hext_apple.mdl";
ITEM.weight = 0.2;
ITEM.health = 2;
ITEM.hunger = 15;
ITEM.thirst = 5;
ITEM.access = "u";
ITEM.business = true;
ITEM.category = "UU-Branded Items";
ITEM.description = "An entirely synthetic red apple, composed of a flavoured gel inside a silicone shell. It tastes distinctly of apple candy, but saccharin sweet.";

ITEM:Register();