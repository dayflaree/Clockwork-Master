--[[
	Free Clockwork!
--]]

Clockwork.storage = Clockwork:NewLibrary("Storage");

-- A function to get whether storage is open.
function Clockwork.storage:IsStorageOpen()
	local panel = self:GetPanel();
	
	if (IsValid(panel) and panel:IsVisible()) then
		return true;
	end;
end;

-- A function to get whether the local player can give to storage.
function Clockwork.storage:CanGiveTo(itemTable)
	local entity = Clockwork.storage:GetEntity();
	
	if (itemTable and IsValid(entity)) then
		local allowPlayerStorage = (!entity:IsPlayer() or itemTable("allowPlayerStorage") != false);
		local allowEntityStorage = (entity:IsPlayer() or itemTable("allowEntityStorage") != false);
		local allowPlayerGive = (!entity:IsPlayer() or itemTable("allowPlayerGive") != false);
		local allowEntityGive = (entity:IsPlayer() or itemTable("allowEntityGive") != false);
		local allowStorage = (itemTable("allowStorage") != false);
		local bIsShipment = (entity and entity:GetClass() == "cw_shipment");
		local allowGive = (itemTable("allowGive") != false);
		
		if (bIsShipment or (allowPlayerStorage and allowPlayerGive and allowStorage and allowGive)) then
			return true;
		end;
	end;
end;

-- A function to get whether the local player can take from storage.
function Clockwork.storage:CanTakeFrom(itemTable)
	local entity = Clockwork.storage:GetEntity();
	
	if (itemTable and IsValid(entity)) then
		local allowPlayerStorage = (!entity:IsPlayer() or itemTable("allowPlayerStorage") != false);
		local allowEntityStorage = (entity:IsPlayer() or itemTable("allowEntityStorage") != false);
		local allowPlayerTake = (!entity:IsPlayer() or itemTable("allowPlayerTake") != false);
		local allowEntityTake = (entity:IsPlayer() or itemTable("allowEntityTake") != false);
		local allowStorage = (itemTable("allowStorage") != false);
		local bIsShipment = (entity and entity:GetClass() == "cw_shipment");
		local allowTake = (itemTable("allowTake") != false);
		
		if (bIsShipment or (allowPlayerStorage and allowPlayerTake and allowStorage and allowTake)) then
			return true;
		end;
	end;
end;

-- A function to get whether there is no cash weight.
function Clockwork.storage:GetNoCashWeight()
	return self.noCashWeight;
end;

-- A function to get the storage inventory.
function Clockwork.storage:GetInventory()
	return self.inventory;
end;

-- A function to get the storage cash.
function Clockwork.storage:GetCash()
	if (Clockwork.config:Get("cash_enabled"):Get()) then
		return self.cash;
	else
		return 0;
	end;
end;

-- A function to get the storage panel.
function Clockwork.storage:GetPanel()
	return self.panel;
end;

-- A function to get the storage weight.
function Clockwork.storage:GetWeight()
	return self.weight;
end;

-- A function to get the storage entity.
function Clockwork.storage:GetEntity()
	return self.entity;
end;

-- A function to get the storage name.
function Clockwork.storage:GetName()
	return self.name;
end;