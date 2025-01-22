local ITEM = Clockwork.item:New();
ITEM.name = "Empty 9mm Ammo Box";
ITEM.uniqueID = "empty_pistol_ammo";
ITEM.spawnValue = 15;
ITEM.spawnType = "junk";
ITEM.cost = 8;
ITEM.model = "models/Items/BoxSRounds.mdl";
ITEM.weight = 0.5;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty metal box that used to contain 9x19mm Parabellum bullets.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();