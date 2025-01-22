local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Meal, Ready-to-Eat";
ITEM.uniqueID = "mre";
ITEM.health = 10;
ITEM.thirst = 50;
ITEM.hunger = 50;
ITEM.model = "models/warz/consumables/bag_mre.mdl";
ITEM.weight = 1;
ITEM.business = false;
ITEM.description = "An old, pre-war packaged meal. Judging by the Cyrillic lettering, it was likely recovered from some post-Soviet bunker somewhere. No clue what's inside, but it should fill you up good.";

ITEM:Register();