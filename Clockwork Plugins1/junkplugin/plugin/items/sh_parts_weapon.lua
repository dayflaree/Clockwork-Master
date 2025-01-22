local ITEM = Clockwork.item:New();
ITEM.name = "Weapon Parts";
ITEM.uniqueID = "parts_weapon";
ITEM.cost = 8;
ITEM.model = "models/gibs/scanner_gib04.mdl";
ITEM.weight = 3.2;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "A bunch of general weapon parts, could maybe be used for something?";
ITEM.spawnValue = 3;
ITEM.spawnType = "crafting";

function ITEM:OnDrop(player, position) end;

ITEM:Register();