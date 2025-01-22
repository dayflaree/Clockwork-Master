local ITEM = Clockwork.item:New();
ITEM.name = "Empty MP7 Ammo Box";
ITEM.uniqueID = "empty_smg_box";
ITEM.spawnValue = 10;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/Items/BoxMRounds.mdl";
ITEM.weight = 0.5;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty metal box that used to contain MP7 bullets.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();