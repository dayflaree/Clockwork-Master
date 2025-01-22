
-----------------------------------------------------
local ITEM = Clockwork.item:New();
ITEM.name = "Level 5 ID Keycard";
ITEM.cost = 500;
ITEM.model = "models/gibs/metal_gib4.mdl";
ITEM.weight = 0.1;
ITEM.access = "I";
ITEM.category = "ID Keycard";
ITEM.business = true;
ITEM.description = "A flat plastic card, reads 'Level 5 ID Card'";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();