local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Box of Tortellinis";
ITEM.uniqueID = "tortellinis";
ITEM.plural = "Boxes of Tortellinis";
ITEM.cost = 60;
ITEM.model = "models/pg_props/pg_food/pg_tortellinis.mdl";
ITEM.weight = 0.5;
ITEM.health = 3;
ITEM.hunger = 30;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "A box of Tortellini with Spinach. There are plenty of nutrients and carbohydrates to be found inside. I'm the fuckin' tortellini master!";
ITEM.spawnValue = 20;
ITEM.spawnType = "consumable";

ITEM:Register();