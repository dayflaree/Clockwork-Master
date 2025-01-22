local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Peanuts";
ITEM.uniqueID = "peanuts";
ITEM.spawnValue = 25;
ITEM.spawnType = "consumable";
ITEM.cost = 7;
ITEM.hunger = 15;
ITEM.model = "models/bioshockinfinite/bag_of_peanuts.mdl";
ITEM.weight = 0.1;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "A classic, burlap bag filled with salted, roasted peanuts. More dangerous to you than OTA, if you have an allergy.";

ITEM:Register();