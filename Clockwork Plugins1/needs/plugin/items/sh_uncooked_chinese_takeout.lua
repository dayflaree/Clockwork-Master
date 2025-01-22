local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Uncooked Chinese Takeout";
ITEM.uniqueID = "uncooked_chinese_takeout";
ITEM.spawnValue = 17;
ITEM.spawnType = "consumable";
ITEM.cost = 25;
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.weight = 0.8;
ITEM.hunger = 5;
ITEM.junk = "empty_chinese_takeout";
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "A box of uncooked noodles.";

ITEM:Register();