local ITEM = Clockwork.item:New();
ITEM.name = "Plastic Bottle";
ITEM.uniqueID = "plastic_bottle";
ITEM.spawnValue = 30;
ITEM.spawnType = "junk";
ITEM.model = "models/props_junk/garbage_plasticbottle001a.mdl";
ITEM.weight = 0.2;
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty plastic bottle.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();