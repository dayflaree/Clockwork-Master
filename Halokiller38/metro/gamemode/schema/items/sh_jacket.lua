--[[
Name: "sh_jacket.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.name = "Jacket";
ITEM.model = "models/fallout 3/backpack_2.mdl";
ITEM.weight = 2;
ITEM.category = "Storage";
ITEM.isRareItem = true;
ITEM.description = "An old jacket, you think this'll hold anything?";
ITEM.extraInventory = 4;
ITEM.cost = 35;
ITEM.access = "y";
ITEM.business = true;


-- Called when the item's drop entity should be created.
function ITEM:OnCreateDropEntity(player, position)
	return openAura.entity:CreateItem(player, "boxed_jacket", position);
end;

-- Called when a player attempts to take the item from storage.
function ITEM:CanTakeStorage(player, storageTable)
	local target = openAura.entity:GetPlayer(storageTable.entity);
	
	if (target) then
		if ( openAura.inventory:GetWeight(target) > (openAura.inventory:GetMaximumWeight(target) - self.extraInventory) ) then
			return false;
		end;
	end;
	
	if (player:HasItem(self.uniqueID) and player:HasItem(self.uniqueID) >= 1) then
		return false;
	end;
end;

-- Called when a player attempts to pick up the item.
function ITEM:CanPickup(player, quickUse, itemEntity)
	return "boxed_storage_jacket";
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if ( openAura.inventory:GetWeight(player) > (openAura.inventory:GetMaximumWeight(player) - self.extraInventory) ) then
		openAura.player:Notify(player, "You cannot drop this while you are carrying items in it!");
		
		return false;
	end;
end;

openAura.item:Register(ITEM);