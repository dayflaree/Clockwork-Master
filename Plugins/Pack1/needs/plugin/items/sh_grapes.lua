local ITEM = Clockwork.item:New();
ITEM.name = "Bag of Grapes";
ITEM.spawnValue = 23;
ITEM.spawnType = "consumable";
ITEM.model = "models/props_junk/garbage_bag001a.mdl";
ITEM.weight = 0.1;
ITEM.hunger = 12;
ITEM.thirst = 5;
ITEM.access = "jM";
ITEM.uniqueID = "grapes";
ITEM.business = false;
ITEM.description = "A bag of fresh grapes, likely grown in one of several vineyards located in the Outlands. Makes a tasty snack, or can be distilled into wine.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();