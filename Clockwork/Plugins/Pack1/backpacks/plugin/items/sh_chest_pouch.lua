
local ITEM = Clockwork.item:New("backpack_base");
ITEM.name = "Chest Pouches";
ITEM.uniqueID = "chest_pouch";
ITEM.model = "models/props_junk/cardboard_box003b.mdl";
ITEM.actualWeight = 1;
ITEM.invSpace = 2.5;
ITEM.slot = "chest";
ITEM.slotSpace = 10;
ITEM.description = "A chest rig with pouches all over it, very good to keep things at hand.";

ITEM:Register();