local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Egg";
ITEM.uniqueID = "egg";
ITEM.cost = 30;
ITEM.health = 1;
ITEM.hunger = 10;
ITEM.model = "models/props_phx/misc/egg.mdl";
ITEM.weight = 0.2;
ITEM.description = "A bird egg. Not necessarily a chicken's, just a bird's. It could be good to eat, or not. You won't know until you crack it open.";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 10;

ITEM:Register();