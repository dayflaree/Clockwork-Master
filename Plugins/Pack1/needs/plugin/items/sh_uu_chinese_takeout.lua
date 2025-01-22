local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Chinese Takeout";
ITEM.uniqueID = "uu_chinese_takeout"
ITEM.cost = 40;
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.weight = 0.8;
ITEM.health = 3;
ITEM.hunger = 40;
ITEM.junk = "empty_chinese_takeout";
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = false;
ITEM.description = "A cardboard box adorning the UU Brand, filled with rice noodles and a petty meat substitute, in a thin watery sauce. It tastes bland, watery and boring, but the MSG keeps it popular.";

ITEM:Register();