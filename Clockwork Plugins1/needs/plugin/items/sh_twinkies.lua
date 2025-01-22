local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Twinkies";
ITEM.uniqueID = "twinkies";
ITEM.model = "models/warz/consumables/minisaints.mdl";
ITEM.description = "The classic, cream-filled American classic. Guess it's true what they say- these things are packed full of so many preservatives that they never really expire.";
ITEM.weight = 0.05;
ITEM.hunger = 10;
ITEM.health = 5;
ITEM.cost = 8;
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnValue = 50;
ITEM.spawnType = "consumable";

ITEM:Register();