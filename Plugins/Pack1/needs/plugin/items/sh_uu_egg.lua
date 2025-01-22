local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Egg";
ITEM.uniqueID = "uu_egg";
ITEM.cost = 30;
ITEM.health = 1;
ITEM.hunger = 10;
ITEM.model = "models/props_phx/misc/egg.mdl";
ITEM.weight = 0.2;
ITEM.access = "u";
ITEM.business = true;
ITEM.category = "UU-Branded Items";
ITEM.description = "An egg with a UU Brand printed upon the side. It appears to be completely normal, until it is cracked open, at which point one would notice that the yoke and white don't seem to be separate entities.";

ITEM:Register();