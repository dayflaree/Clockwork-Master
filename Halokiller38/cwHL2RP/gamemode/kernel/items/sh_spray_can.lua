--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New();
ITEM.batch = 1;
ITEM.name = "Spray Can";
ITEM.cost = 150;
ITEM.model = "models/sprayca2.mdl";
ITEM.weight = 1;
ITEM.category = "Reusables"
ITEM.business = true;
ITEM.batch = 1;
ITEM.access = "v";
ITEM.description = "A standard spray can filled with paint.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

Clockwork.item:Register(ITEM);