--[[
Name: "sh_backpack.lua".
Product: "Skeleton".
--]]

--[[
	There are so many more options to choose from to customise your item to the maximum.
	But I cannot really document it fully, so make sure to check the entire nexus framework
	for cool little tricks and variables you can use with your items.
--]]

-- Create a table to store our item in.
local ITEM = {};

ITEM.name = "Backpack"; -- The name of the item, obviously.
ITEM.model = "models/props_junk/garbage_bag001a.mdl"; -- What model does the item use.
ITEM.weight = 2; -- How much does it weigh in kg?
ITEM.category = "Storage";
ITEM.isRareItem = true; -- What category does the item belong in?
ITEM.description = "A tattered backpack, it doesn't look like it will hold much."; -- Give a small description of the item.
ITEM.extraInventory = 8; -- How much extra inventory do you get for having this item (advised that you add the weight to it).

--[[
	Called when the item's drop entity should be created.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:OnCreateDropEntity(player, position)
	return nexus.entity.CreateItem(player, "boxed_backpack", position);
end;

--[[
	Called when a player attempts to take the item from storage.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:CanTakeStorage(player, storageTable)
	local target = nexus.entity.GetPlayer(storageTable.entity);
	
	if (target) then
		if ( nexus.inventory.GetWeight(target) > (nexus.inventory.GetMaximumWeight(target) - self.extraInventory) ) then
			return false;
		end;
	end;
	
	if (player:HasItem(self.uniqueID) and player:HasItem(self.uniqueID) >= 1) then
		return false;
	end;
end;

--[[
	Called when a player attempts to pick up the item.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:CanPickup(player, quickUse, itemEntity)
	return "boxed_backpack";
end;

--[[
	Called when a player drops the item.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:OnDrop(player, position)
	-- If the item doesn't have this function, it cannot be dropped.
	
	if ( nexus.inventory.GetWeight(player) > (nexus.inventory.GetMaximumWeight(player) - self.extraInventory) ) then
		nexus.player.Notify(player, "You cannot drop this while you are carrying items in it!");
		
		return false;
	end;
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