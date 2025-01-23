--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.name = "Backpack";
ITEM.model = "models/avoxgaming/mrp/jake/props/backpack.mdl";
ITEM.weight = 2;
ITEM.category = "Storage";
ITEM.isRareItem = true;
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 270, 270);
ITEM.attachmentOffsetVector = Vector(0, -2, -9);
ITEM.description = "A tattered backpack, it doesn't look like it will hold much.";
ITEM.extraInventory = 8;

-- Called when the item's drop entity should be created.
function ITEM:OnCreateDropEntity(player, position)
	return openAura.entity:CreateItem(player, "boxed_backpack", position);
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
	return "boxed_backpack";
end;

-- Called when the attachment offset info should be adjusted.
function ITEM:AdjustAttachmentOffsetInfo(player, entity, info)
	if ( string.find(player:GetModel(), "female") ) then
		info.offsetVector = Vector(0, 0, 0);
	end;
end;

-- A function to get whether the attachment is visible.
function ITEM:GetAttachmentVisible(player, entity)
	if ( player:GetSharedVar("backpack") ) then
		return true;
	end;
end;

-- Called when the item's local amount is needed.
function ITEM:GetLocalAmount(amount)
	if ( openAura.Client:GetSharedVar("backpack") ) then
		return amount - 1;
	else
		return amount;
	end;
end;

-- Called to get whether a player has the item equipped.
function ITEM:HasPlayerEquipped(player, arguments)
	return player:GetSharedVar("backpack");
end;

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player, arguments)
	local skullMaskGear = openAura.player:GetGear(player, "backpack");
	
	if ( player:GetSharedVar("backpack") and IsValid(skullMaskGear) ) then
		player:SetCharacterData("backpack", nil);
		player:SetSharedVar("backpack", false);
		
		if ( IsValid(backpackGear) ) then
			backpackGear:Remove();
		end;
	end;
	player:UpdateInventory(self.uniqueID);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if (player:GetSharedVar("backpack") and player:HasItem(self.uniqueID) == 1) then
		openAura.player:Notify(player, "You cannot drop this while you are wearing it!");
		
		return false;
	end;
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if ( player:Alive() and !player:IsRagdolled() ) then
		openAura.player:CreateGear(player, "backpack", self);
		
		player:SetCharacterData("backpack", true);
		player:SetSharedVar("backpack", true);
		player:UpdateInventory(self.uniqueID);
		
		
		if (itemEntity) then
		itemEntity:Remove();
			return true;
		end;
	else
		openAura.player:Notify(player, "You don't have permission to do this right now!");
	end;
	
	
	
	return false;
end;

openAura.item:Register(ITEM);