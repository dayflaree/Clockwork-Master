local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Pickles";
ITEM.uniqueID = "uu_pickles";
ITEM.cost = 60;
ITEM.model = "models/bioshockinfinite/dickle_jar.mdl";
ITEM.weight = 0.5;
ITEM.health = 2;
ITEM.hunger = 25;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A jar of preserved pickles, adorning the UU logo. They're oddly mushy and taste a bit like sponge.";
 
ITEM:Register();