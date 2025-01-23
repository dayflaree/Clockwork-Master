--[[
Name: "sh_backpack.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.name = "Backpack";
ITEM.model = "models/props_junk/garbage_bag001a.mdl";
ITEM.weight = 0.1;
ITEM.category = "Storage";
ITEM.isRareItem = true;
ITEM.description = "A tattered backpack, it doesn't look like it will hold much.";
ITEM.extraInventory = 5;

-- Called when the item's drop entity should be created.
function ITEM:OnCreateDropEntity(player, position)
	return blueprint.entity.CreateItem(player, "boxed_backpack", position);
end;

-- Called when a player attempts to take the item from storage.
function ITEM:CanTakeStorage(player, storageTable)
	local target = blueprint.entity.GetPlayer(storageTable.entity);
	
	if (target) then
		if ( blueprint.inventory.GetWeight(target) > (blueprint.inventory.GetMaximumWeight(target) - self.extraInventory) ) then
			return false;
		end;
	end;
	
	if (player:HasItem(self.uniqueID) and player:HasItem(self.uniqueID) >= 1) then
		return false;
	end;
end;

-- Called when a player attempts to pick up the item.
function ITEM:CanPickup(player, quickUse, itemEntity)
	return "boxed_backpack";
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if ( blueprint.inventory.GetWeight(player) > (blueprint.inventory.GetMaximumWeight(player) - self.extraInventory) ) then
		blueprint.player.Notify(player, "You cannot drop this while you are carrying items in it!");
		
		return false;
	end;
end;

blueprint.item.Register(ITEM);