local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Canned Spam";
ITEM.uniqueID = "spam";
ITEM.health = 10;
ITEM.hunger = 25;
ITEM.model = "models/warz/consumables/can_spam.mdl";
ITEM.weight = 0.2;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.description = "The iconic rectangular can of fake, greasy meat. Despite its appearance and smell, it's actually quite tasty when grilled.";
 
ITEM:Register();