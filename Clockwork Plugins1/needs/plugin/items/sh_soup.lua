local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Tomato Soup";
ITEM.uniqueID = "soup";
ITEM.thirst = 20;
ITEM.hunger = 30;
ITEM.health = 10;
ITEM.junk = "rusty_can";
ITEM.model = "models/warz/consumables/can_soup.mdl";
ITEM.weight = 0.2;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "A can of hearty tomato soup, ideal for both sating your appetite and quenching your thirst. Now if only you had some grilled cheese to go alongside it...";

ITEM:Register();