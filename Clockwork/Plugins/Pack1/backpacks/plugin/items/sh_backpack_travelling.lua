local ITEM = Clockwork.item:New("backpack_base");
ITEM.name = "Travelling Backpack";
ITEM.uniqueID = "backpack_travelling";
ITEM.model = "models/dpfilms/metropolice/props/metrold_backpack.mdl";
ITEM.actualWeight = 5;
ITEM.invSpace = 12;
ITEM.slot = "back";
ITEM.slotSpace = 6;
ITEM.description = "A fresh, homemade backpack designed for carrying items fit for travelling.";

ITEM:Register();