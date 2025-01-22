local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Corn on the Cob";
ITEM.uniqueID = "corn";
ITEM.cost = 60;
ITEM.health = 10;
ITEM.hunger = 20;
ITEM.model = "models/bioshockinfinite/corn_on_cob.mdl";
ITEM.weight = 1;
ITEM.business = false;
ITEM.description = "A cob of corn, still attached to the sheaf. It appears fresh and ready to consume.";
 
ITEM:Register();