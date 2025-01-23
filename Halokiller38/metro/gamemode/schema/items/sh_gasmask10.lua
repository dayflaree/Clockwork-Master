ITEM = openAura.item:New();
ITEM.name = "Respirator";
ITEM.model = "models/avoxgaming/mrp/jake/props/resperator.mdl";
ITEM.weight = 0.25;
ITEM.batch = 1;
ITEM.business = true;
ITEM.category = "Clothing";
ITEM.description = "A small mask, it won't protect your eyes.";
ITEM.isAttachment = true;
ITEM.useSound = "avoxgaming/timer/timer.wav";
ITEM.useText = "Equip";
ITEM.attachmentBone = "ValveBiped.Bip01_Head1";
ITEM.attachmentOffsetAngles = Angle(-90, -84.71, 0);
ITEM.attachmentOffsetVector = Vector(-0.1, 1.1, -3);
ITEM.access = "U";
ITEM.cost = 20;

-- Called when the attachment offset info should be adjusted.
function ITEM:AdjustAttachmentOffsetInfo(player, entity, info)
	if ( string.find(player:GetModel(), "female") ) then
		info.offsetVector = Vector(0, 0, 0);
	end;
end;

-- A function to get whether the attachment is visible.
function ITEM:GetAttachmentVisible(player, entity)
	if ( player:GetSharedVar("gasmask10") ) then
		return true;
	end;
end;

-- Called when the item's local amount is needed.
function ITEM:GetLocalAmount(amount)
	if ( openAura.Client:GetSharedVar("gasmask10") ) then
		return amount - 1;
	else
		return amount;
	end;
end;

-- Called to get whether a player has the item equipped.
function ITEM:HasPlayerEquipped(player, arguments)
	return player:GetSharedVar("gasmask10");
end;

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player, arguments)
	local skullMaskGear = openAura.player:GetGear(player, "gasmask10");
	
	if ( player:GetSharedVar("gasmask10") and IsValid(skullMaskGear) ) then
		player:SetCharacterData("gasmask10", nil);
		player:SetSharedVar("gasmask10", false);
		player:SetSharedVar("wearingRespirator", false);
		
		if ( IsValid(gasmask10Gear) ) then
			gasmask10Gear:Remove();
		end;
	end;
	player:UpdateInventory(self.uniqueID);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if (player:GetSharedVar("gasmask10") and player:HasItem(self.uniqueID) == 1) then
		openAura.player:Notify(player, "You cannot drop this while you are wearing it!");
		
		return false;
	end;
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if ( player:Alive() and !player:IsRagdolled() ) then
		openAura.player:CreateGear(player, "gasmask10", self);
		
		player:SetCharacterData("gasmask10", true);
		player:SetSharedVar("gasmask10", true);
		player:SetSharedVar("wearingRespirator", true);
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