local ITEM = Clockwork.item:New();
ITEM.name = "Empty Paint Can";
ITEM.spawnValue = 20;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/props_junk/metal_paintcan001a.mdl";
ITEM.weight = 0.5;
ITEM.access = "jM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty can of paint.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();