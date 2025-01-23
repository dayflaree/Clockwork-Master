ITEM = openAura.item:New();
ITEM.name = "Iron Helmet";
ITEM.model = "models/avoxgaming/mrp/jake/props/helmet_iron.mdl";
ITEM.weight = 0.4;
ITEM.batch = 1;
ITEM.business = true;
ITEM.category = "Clothing";
ITEM.description = "A heavy, iron helmet.";
ITEM.isAttachment = true;
ITEM.useSound = "avoxgaming/timer/timer.wav";
ITEM.useText = "Equip";
ITEM.attachmentBone = "ValveBiped.Bip01_Head1";
ITEM.attachmentOffsetAngles = Angle(-90, -84.71, 0);
ITEM.attachmentOffsetVector = Vector(0, 1.03, -1);
ITEM.access = "U";
ITEM.cost = 27;

-- Called when the attachment offset info should be adjusted.
function ITEM:AdjustAttachmentOffsetInfo(player, entity, info)
	if ( string.find(player:GetModel(), "female") ) then
		info.offsetVector = Vector(0, 0, 0);
	end;
end;

-- A function to get whether the attachment is visible.
function ITEM:GetAttachmentVisible(player, entity)
	if ( player:GetSharedVar("gasmask9") ) then
		return true;
	end;
end;

-- Called when the item's local amount is needed.
function ITEM:GetLocalAmount(amount)
	if ( openAura.Client:GetSharedVar("gasmask9") ) then
		return amount - 1;
	else
		return amount;
	end;
end;

-- Called to get whether a player has the item equipped.
function ITEM:HasPlayerEquipped(player, arguments)
	return player:GetSharedVar("gasmask9");
end;

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player, arguments)
	local skullMaskGear = openAura.player:GetGear(player, "gasmask9");
	
	if ( player:GetSharedVar("gasmask9") and IsValid(skullMaskGear) ) then
		player:SetCharacterData("gasmask9", nil);
		player:SetSharedVar("gasmask9", false);
		player:SetSharedVar("wearingRespirator", false);
		
		if ( IsValid(gasmask9Gear) ) then
			gasmask9Gear:Remove();
		end;
	end;
	player:UpdateInventory(self.uniqueID);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if (player:GetSharedVar("gasmask9") and player:HasItem(self.uniqueID) == 1) then
		openAura.player:Notify(player, "You cannot drop this while you are wearing it!");
		
		return false;
	end;
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if ( player:Alive() and !player:IsRagdolled() ) then
		openAura.player:CreateGear(player, "gasmask9", self);
		
		player:SetCharacterData("gasmask9", true);
		player:SetSharedVar("gasmask9", true);
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