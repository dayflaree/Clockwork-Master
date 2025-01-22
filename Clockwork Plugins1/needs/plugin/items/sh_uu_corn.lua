local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Corn";
ITEM.uniqueID = "uu_corn";
ITEM.cost = 60;
ITEM.health = 10;
ITEM.hunger = 20;
ITEM.model = "models/bioshockinfinite/porn_on_cob.mdl";
ITEM.weight = 1;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A bizarre looking synthetic cob of corn, attached to a silicone sheaf. It seems barely edible, but is bound to boast some calories.";
 
ITEM:Register();