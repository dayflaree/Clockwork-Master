local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Canned Mystery Meat";
ITEM.uniqueID = "canned_mystery_meat";
ITEM.model = "models/bioshockinfinite/canned_soup.mdl";
ITEM.description = "A tomato can, filled with green coloured spicy meat, could it be Antlion?";
ITEM.weight = 0.2;
ITEM.hunger = 40;
ITEM.thirst = -10;
ITEM.health = 7;
ITEM.junk = "rusty_can";
ITEM.business = false;
ITEM.access = "Mv";

ITEM:Register();