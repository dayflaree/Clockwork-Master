local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Antlion Meat";
ITEM.uniqueID = "antlion_meat";
ITEM.hunger = 60;
ITEM.health = 12;
ITEM.model = "models/gibs/humans/mgib_01.mdl";
ITEM.weight = 0.8;
ITEM.access = "Mv";
ITEM.business = false;
ITEM.description = "A hunk of cooked antlion flesh. It appears chargrilled and succulent, with plenty of calories to keep you going as you trudge through the subvectors.";

ITEM:Register();