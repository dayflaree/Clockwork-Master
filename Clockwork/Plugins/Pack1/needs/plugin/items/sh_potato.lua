local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Potato";
ITEM.uniqueID = "potato";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 18;
ITEM.plural = "Potatoes";
ITEM.model = "models/bioshockinfinite/loot_potato.mdl";
ITEM.cost = 12;
ITEM.hunger = 15;
ITEM.weight = 0.15;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "A freshly grown potato. No weird stalks growing from it. It seems perfect for mashing, and partnering with lashings of gravy.";

ITEM:Register();