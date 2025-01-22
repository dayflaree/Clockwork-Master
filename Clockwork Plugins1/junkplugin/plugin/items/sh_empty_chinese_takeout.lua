local ITEM = Clockwork.item:New();
ITEM.name = "Empty Chinese Takeout";
ITEM.uniqueID = "empty_chinese_takeout";
ITEM.spawnValue = 55;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.weight = 0.5;
ITEM.access = "jM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty box of chinese takeout.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();