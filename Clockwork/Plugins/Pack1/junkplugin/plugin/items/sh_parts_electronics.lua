local ITEM = Clockwork.item:New();
ITEM.name = "Scrap Electronics";
ITEM.uniqueID = "parts_electronic";
ITEM.cost = 8;
ITEM.model = "models/gibs/airboat_broken_engine.mdl";
ITEM.weight = 10;
ITEM.access = "JM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "A massive hunk of scrap electronics and metal";
ITEM.spawnValue = 3;
ITEM.spawnType = "crafting";

function ITEM:OnDrop(player, position) end;

ITEM:Register();