local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Canned Tuna";
ITEM.uniqueID = "tuna";
ITEM.model = "models/warz/consumables/can_tuna.mdl";
ITEM.weight = 0.5;
ITEM.health = 5;
ITEM.hunger = 25;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "A tin of salted and packed tuna, apparently caught fresh by various Resistance members in the Outlands. Although not exactly appetizing, it can be eaten raw.";
 
ITEM:Register();