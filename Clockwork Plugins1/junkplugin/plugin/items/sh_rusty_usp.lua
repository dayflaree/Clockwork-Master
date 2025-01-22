local ITEM = Clockwork.item:New();
ITEM.name = "Rusty USP";
ITEM.spawnValue = 2;
ITEM.spawnType = "crafting";
ITEM.cost = 8;
ITEM.model = "models/Weapons/W_pistol.mdl";
ITEM.weight = 1;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "A rusted Heckler and Koch USP-Match.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();