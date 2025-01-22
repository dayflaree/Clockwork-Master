local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Cheeseburger";
ITEM.uniqueID = "uu_cheeseburger";
ITEM.cost = 75;
ITEM.model = "models/food/burger.mdl";
ITEM.weight = 0.5;
ITEM.health = 25;
ITEM.hunger = 100;
ITEM.access = "u";
ITEM.business = true;
ITEM.category = "UU-Branded Items";
ITEM.description = "A delicious, hot, melty cheeseburger with a Union sticker on the bun.";

ITEM:Register();