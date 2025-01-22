local ITEM = Clockwork.item:New();
ITEM.name = "Coffee Machine";
ITEM.model = "models/props_office/coffe_machine.mdl";
ITEM.uniqueID = "wi_coffee_machine";
ITEM.craftingStation = true;
ITEM.weight = 2;
ITEM.category = "Crafting Station";
ITEM.business = false;
ITEM.description = "A coffee machine.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

function ITEM:CanPickup(player, bQuickUse, entity)
	return false;
end;

ITEM:Register();