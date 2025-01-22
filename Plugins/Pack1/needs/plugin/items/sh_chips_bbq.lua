local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Barbecue Chips";
ITEM.uniqueID = "chips_bbq";
ITEM.model = "models/warz/consumables/bag_chips.mdl";
ITEM.description = "A packet of off-brand BBQ chips. It doesn't really taste like actual barbecue, but it's got a faux smoky flavor, and is pretty tasty in its own right.";
ITEM.weight = 0.2;
ITEM.hunger = 20;
ITEM.health = 3;
ITEM.cost = 7;
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnValue = 15;
ITEM.spawnType = "consumable";

ITEM:Register();