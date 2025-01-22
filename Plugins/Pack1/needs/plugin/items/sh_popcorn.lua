local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Popcorn";
ITEM.uniqueID = "popcorn";
ITEM.cost = 7;
ITEM.hunger = 15;
ITEM.model = "models/bioshockinfinite/popcorn_bag.mdl";
ITEM.weight = 0.3;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "A bag of sealed popcorn. It might not be warm or buttery, but it reminds you of seeing movies at the theatre. This particular bag is salted.";

ITEM:Register();