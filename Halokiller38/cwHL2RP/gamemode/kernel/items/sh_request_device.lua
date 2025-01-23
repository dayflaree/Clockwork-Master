--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New();
ITEM.batch = 1;
ITEM.name = "Request Device Mark-1";
ITEM.uniqueID = "request_device"
ITEM.cost = 15;
ITEM.model = "models/gibs/shield_scanner_gib1.mdl";
ITEM.weight = 0.8;
ITEM.category = "Communication";
ITEM.factions = {FACTION_MPF};
ITEM.business = true;
ITEM.description = "A prototype device created by the Combine for loyalists of the city.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

Clockwork.item:Register(ITEM);