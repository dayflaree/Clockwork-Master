local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Uncooked Canned Beans";
ITEM.uniqueID = "uncooked_canned_beans";
ITEM.spawnValue = 15;
ITEM.spawnType = "consumable";
ITEM.cost = 25;
ITEM.hunger = 5;
ITEM.model = "models/bioshockinfinite/baked_beans.mdl";
ITEM.weight = 0.2;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "A sealed, uncooked can of baked beans in tomato sauce. They seem fairly calorific, the label would indicate.";

ITEM:Register();