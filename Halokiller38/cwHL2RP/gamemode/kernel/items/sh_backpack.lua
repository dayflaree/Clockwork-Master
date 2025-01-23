--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("custom_storage");
	ITEM.name = "Backpack";
	ITEM.cost = 100;
	ITEM.description = "An old and tattered vintage style backpack.";
	ITEM.extraInventory = 16;
	ITEM.business = true;
	ITEM.batch = 1;
Clockwork.item:Register(ITEM);