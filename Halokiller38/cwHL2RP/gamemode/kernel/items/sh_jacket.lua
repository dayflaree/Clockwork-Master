--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("custom_storage");
	ITEM.name = "Jacket";
	ITEM.cost = 50;
	ITEM.description = "A small and tattered storage jacket.";
	ITEM.extraInventory = 6;
	ITEM.access = "v";
	ITEM.batch = 1;
Clockwork.item:Register(ITEM);