local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Uncooked UU-Branded Chinese Takeout";
ITEM.uniqueID = "uncooked_uu_chinese_takeout";
ITEM.cost = 30;
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.weight = 0.8;
ITEM.hunger = 15;
ITEM.junk = "empty_chinese_takeout";
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A cardboard box adorning the UU Brand, filled with raw rice noodles and a petty meat substitute, in a cold watery sauce. It tastes bland, watery and boring, but the MSG keeps it popular.";

ITEM:Register();