--[[
Name: "sh_boxed_backpack.lua".
Product: "Skeleton".
--]]

--[[
	There are so many more options to choose from to customise your item to the maximum.
	But I cannot really document it fully, so make sure to check the entire nexus framework
	for cool little tricks and variables you can use with your items.
--]]

-- Create a table to store our item in.
local ITEM = {};

ITEM.name = "Boxed Backpack"; -- The name of the item, obviously.
ITEM.cost = 25; -- How much does this item cost for people with business access to it?
ITEM.model = "models/props_junk/cardboard_box004a.mdl"; -- What model does the item use.
ITEM.weight = 2; -- How much does it weigh in kg?
ITEM.access = "M"; -- What flags do you need to have access to this item in your business menu (you only need one of them)?
ITEM.useText = "Open"; -- What does the text say instead of Use, remove this line to keep it as Use.
ITEM.category = "Storage"; -- What category does the item belong in?
ITEM.business = true; -- Is this item available on the business menu (if the player has access to it)?
ITEM.description = "A brown box, open it to reveal its contents."; -- Give a small description of the item.

--[[
	Called when a player uses the item.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:OnUse(player, itemEntity)
	-- If the item doesn't have this function, it cannot be used.
	
	if (player:HasItem("backpack") and player:HasItem("backpack") >= 1) then
		nexus.player.Notify(player, "You can only have one backpack!");
		
		return false;
	end;
	
	player:UpdateInventory("backpack", 1, true);
end;

--[[
	Called when a player drops the item.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:OnDrop(player, position)
	-- If the item doesn't have this function, it cannot be dropped.
end;

--[[
	Called when a player destroys the item.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:OnDestroy(player)
	-- If the item doesn't have this function, it cannot be destroyed.
end;

-- Register the item to the nexus framework.
nexus.item.Register(ITEM);