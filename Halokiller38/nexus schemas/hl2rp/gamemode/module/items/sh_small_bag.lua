--[[
Name: "sh_small_bag.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.name = "Small Bag";
ITEM.model = "models/props_junk/garbage_bag001a.mdl";
ITEM.weight = 1;
ITEM.category = "Storage";
ITEM.isRareItem = true;
ITEM.description = "A small tattered bag, you would be lucky if it held anything.";
ITEM.extraInventory = 4;

-- Called when the item's drop entity should be created.
function ITEM:OnCreateDropEntity(player, position)
	return resistance.entity.CreateItem(player, "boxed_bag", position);
end;

-- Called when a player attempts to take the item from storage.
function ITEM:CanTakeStorage(player, storageTable)
	local target = resistance.entity.GetPlayer(storageTable.entity);
	
	if (target) then
		if ( resistance.inventory.GetWeight(target) > (resistance.inventory.GetMaximumWeight(target) - self.extraInventory) ) then
			return false;
		end;
	end;
	
	if (player:HasItem(self.uniqueID) and player:HasItem(self.uniqueID) >= 2) then
		return false;
	end;
end;

-- Called when a player attempts to pick up the item.
function ITEM:CanPickup(player, quickUse, itemEntity)
	return "boxed_backpack";
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if ( resistance.inventory.GetWeight(player) > (resistance.inventory.GetMaximumWeight(player) - self.extraInventory) ) then
		resistance.player.Notify(player, "You cannot drop this while you are carrying items in it!");
		
		return false;
	end;
end;

resistance.item.Register(ITEM);