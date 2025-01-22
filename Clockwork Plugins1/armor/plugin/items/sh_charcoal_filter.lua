
local ITEM = Clockwork.item:New("filter_base");
ITEM.name = "Charcoal Filter";
ITEM.uniqueID = "charcoal_filter";
ITEM.model = "models/teebeutel/metro/objects/gasmask_filter.mdl";
ITEM.isRareSpawn = true;
ITEM.spawnValue = 1;
ITEM.cost = 70;
ITEM.weight = 0.5;
ITEM.business = true;
ITEM.maxFilterQuality = 1800;
ITEM.useText = "Screw On";
ITEM.access = "Mv";
ITEM.description = "A filter you can screw onto a gasmask.";
ITEM.refillItem = "charcoal";

Clockwork.item:Register(ITEM);
