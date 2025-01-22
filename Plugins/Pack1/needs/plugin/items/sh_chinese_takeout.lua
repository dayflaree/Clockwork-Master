local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Chinese Takeout";
ITEM.uniqueID = "chinese_takeout";
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.description = "A cardboard box filled with noodles and a meat substitute in a thin black bean sauce. It tastes cheap, salty and distinctly of MSG; but it's tasty, and reminds you of home.";
ITEM.weight = 0.8;
ITEM.hunger = 40;
ITEM.health = 8;
ITEM.junk = "empty_chinese_takeout";
ITEM.cost = 35;
ITEM.business = false;
ITEM.access = "Mv";
ITEM.spawnValue = 5;
ITEM.spawnType = "consumable";

ITEM:Register();