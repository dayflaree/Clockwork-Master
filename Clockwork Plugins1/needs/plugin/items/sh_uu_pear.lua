local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Pear";
ITEM.uniqueID = "uu_pear";
ITEM.cost = 30;
ITEM.model = "models/bioshockinfinite/hext_pear.mdl";
ITEM.weight = 0.2;
ITEM.health = 2;
ITEM.hunger = 15;
ITEM.thirst = 5;
ITEM.access = "u";
ITEM.business = true;
ITEM.category = "UU-Branded Items";
ITEM.description = "A synthetic green fruit, consisting of a pale green gel in a silicone shell. It tastes reminiscent of pear candy, but saccharin sweet.";

ITEM:Register();