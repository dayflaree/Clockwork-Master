local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Popcorn";
ITEM.uniqueID = "uu_popcorn";
ITEM.cost = 20;
ITEM.model = "models/bioshockinfinite/topcorn_bag.mdl";
ITEM.weight = 0.3;
ITEM.health = 1;
ITEM.hunger = 10;
ITEM.access = "u";
ITEM.business = false;
ITEM.category = "UU-Branded Items";
ITEM.description = "A bag of sealed popcorn, adorning the UU Brand. It might not be warm or buttery, but the popcorn within appears to be genuine, reminding you of the theatre.";

ITEM:Register();