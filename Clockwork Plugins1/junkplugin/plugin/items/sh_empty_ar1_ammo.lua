local ITEM = Clockwork.item:New();
ITEM.name = "Empty AK47 Ammo Box";
ITEM.uniqueID = "empty_ar1_box";
ITEM.spawnValue = 7;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/items/ammobox.mdl";
ITEM.weight = 0.5;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty metal box that used to contain Rifle bullets.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();