
local ITEM = Clockwork.item:New("filter_base");
ITEM.name = "Military Grade Filter";
ITEM.uniqueID = "charcoal_filter_upgraded";
ITEM.model = "models/teebeutel/metro/objects/gasmask_filter.mdl";
ITEM.isRareSpawn = true;
ITEM.spawnValue = 1;
ITEM.cost = 400;
ITEM.weight = 0.5;
ITEM.business = true;
ITEM.maxFilterQuality = 7200;
ITEM.useText = "Screw On";
ITEM.access = "Mv";
ITEM.description = "A rare and upgraded Military filter, it appears to be in pristine condition, does not look like you can refill it";

Clockwork.item:Register(ITEM);
