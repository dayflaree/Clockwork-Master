local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Sugar";
ITEM.uniqueID = "wi_sugar";
ITEM.model = "models/gibs/props_canteen/vm_snack21.mdl";
ITEM.weight = 0.1;
ITEM.health = 1;
ITEM.hunger = 5;
ITEM.category = "UU-Branded Items";
ITEM.description = "A small packet of sugar, ideal for sweetening coffee.";

ITEM:Register();