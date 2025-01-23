--[[
	Free Clockwork!
--]]

Clockwork.storage = Clockwork:NewLibrary("Storage");

-- A function to get a player's storage entity.
function Clockwork.storage:GetEntity(player)
	if (player:GetStorageTable()) then
		local entity = self:Query(player, "entity");
		
		if (IsValid(entity)) then
			return entity;
		end;
	end;
end;

-- A function to get a player's storage table.
function Clockwork.storage:GetTable(player)
	return player.cwStorageTab;
end;

-- A function to get whether a player's storage has an item.
function Clockwork.storage:HasItem(player, itemTable)
	local inventory = self:Query(player, "inventory");
	
	if (inventory) then
		return Clockwork.inventory:HasItemInstance(
			inventory, itemTable
		);
	end;
	
	return false;
end;

-- A function to query a player's storage.
function Clockwork.storage:Query(player, key, default)
	local storageTable = player:GetStorageTable();
	
	if (storageTable) then
		return storageTable[key] or default;
	else
		return default;
	end;
end;

-- A function to close storage for a player.
function Clockwork.storage:Close(player, bServer)
	local storageTable = player:GetStorageTable();
	local OnClose = self:Query(player, "OnClose");
	local entity = self:Query(player, "entity");
	
	if (storageTable and OnClose) then
		OnClose(player, storageTable, entity);
	end;
	
	if (!bServer) then
		umsg.Start("cwStorageClose", player);
		umsg.End();
	end;
	
	player.cwStorageTab = nil;
end;

-- A function to get the weight of a player's storage.
function Clockwork.storage:GetWeight(player)
	if (player:GetStorageTable()) then
		local cash = self:Query(player, "cash");
		local weight = (cash * Clockwork.config:Get("cash_weight"):Get());
		local inventory = self:Query(player, "inventory");
		
		if (self:Query(player, "noCashWeight")) then
			weight = 0;
		end;
		
		for k, v in pairs(inventory) do
			local itemTable = Clockwork.item:FindByID(k);
			
			if (itemTable) then
				weight = weight + (math.max(itemTable("storageWeight") or itemTable("weight"), 0) * table.Count(v));
			end;
		end;
		
		return weight;
	else
		return 0;
	end;
end;

-- A function to open storage for a player.
function Clockwork.storage:Open(player, data)
	local storageTable = player:GetStorageTable();
	local OnClose = self:Query(player, "OnClose");
	
	if (storageTable and OnClose) then
		OnClose(player, storageTable, storageTable.entity);
	end;
	
	if (!Clockwork.config:Get("cash_enabled"):Get()) then
		data.cash = nil;
	end;
	
	if (data.noCashWeight == nil) then
		data.noCashWeight = false;
	end;
	
	data.inventory = data.inventory or {};
	data.entity = data.entity or player;
	data.weight = data.weight or Clockwork.config:Get("default_inv_weight"):Get();
	data.cash = data.cash or 0;
	data.name = data.name or "Storage";
	
	player.cwStorageTab = data;
	
	umsg.Start("cwStorageStart", player);
		umsg.Bool(data.noCashWeight);
		umsg.Entity(data.entity);
		umsg.String(data.name);
	umsg.End();
	
	self:UpdateCash(player, data.cash);
	self:UpdateWeight(player, data.weight);
	
	for k, v in pairs(data.inventory) do
		self:UpdateByID(player, k);
	end;
end;

-- A function to update a player's storage cash.
function Clockwork.storage:UpdateCash(player, cash)
	if (Clockwork.config:Get("cash_enabled"):Get()) then
		local storageTable = player:GetStorageTable();
		
		if (storageTable) then
			local inventory = self:Query(player, "inventory");
			
			for k, v in ipairs(_player.GetAll()) do
				if (v:HasInitialized() and v:GetStorageTable()) then
					if (self:Query(v, "inventory") == inventory) then
						v.cwStorageTab.cash = cash;
						
						umsg.Start("cwStorageCash", v);
							umsg.Long(cash);
						umsg.End();
					end;
				end;
			end;
		end;
	end;
end;

-- A function to update a player's storage weight.
function Clockwork.storage:UpdateWeight(player, weight)
	if (player:GetStorageTable()) then
		local inventory = self:Query(player, "inventory");
		
		for k, v in ipairs(_player.GetAll()) do
			if (v:HasInitialized() and v:GetStorageTable()) then
				if (self:Query(v, "inventory") == inventory) then
					v.cwStorageTab.weight = weight;
					
					umsg.Start("cwStorageWeight", v);
						umsg.Float(weight);
					umsg.End();
				end;
			end;
		end;
	end;
end;

-- A function to get whether a player can give to storage.
function Clockwork.storage:CanGiveTo(player, itemTable)
	local entity = self:Query(player, "entity");
	
	if (itemTable) then
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

-- A function to get whether a player can take from storage.
function Clockwork.storage:CanTakeFrom(player, itemTable)
	local entity = self:Query(player, "entity");
	
	if (itemTable) then
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

-- A function to sync a player's cash.
function Clockwork.storage:SyncCash(player)
	local recipientFilter = RecipientFilter();
	local inventory = player:GetInventory();
	local cash = player:GetCash();
	
	if (Clockwork.config:Get("cash_enabled"):Get()) then
		for k, v in ipairs(_player.GetAll()) do
			if (v:HasInitialized() and self:Query(v, "inventory") == inventory) then
				local storageTable = v:GetStorageTable();
					recipientFilter:AddPlayer(v);
				storageTable.cash = cash;
			end;
		end;
	end;
	
	umsg.Start("cwStorageCash", recipientFilter);
		umsg.Long(cash);
	umsg.End();
end;

-- A function to sync a player's item.
function Clockwork.storage:SyncItem(player, itemTable)
	local inventory = player:GetInventory();
	
	if (itemTable) then
		local definition = Clockwork.item:GetDefinition(itemTable, true);
			definition.index = nil;
		local players = {};
		
		for k, v in ipairs(_player.GetAll()) do
			if (v:HasInitialized() and self:Query(v, "inventory") == inventory) then
				players[#players + 1] = v;
			end;
		end;
		
		if (player:HasItemInstance(itemTable)) then
			Clockwork:StartDataStream(players, "StorageGive", { index = itemTable("index"), itemList = {definition}});
		else
			Clockwork:StartDataStream(players, "StorageTake", Clockwork.item:GetSignature(itemTable));
		end;
	end;
end;

-- A function to give an item to a player's storage.
function Clockwork.storage:GiveTo(player, itemTable)
	if (!player:GetStorageTable()) then return; end;
	
	local inventory = self:Query(player, "inventory");
	if (!self:CanGiveTo(player, itemTable)) then
		return;
	end;
	
	Clockwork.inventory:AddInstance(inventory, itemTable);
	
	local definition = Clockwork.item:GetDefinition(itemTable, true);
		definition.index = nil;
	local players = {};
	
	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized() and self:Query(v, "inventory") == inventory) then
			players[#players + 1] = v;
		end;
	end;
	
	Clockwork:StartDataStream(
		players, "StorageGive", { index = itemTable("index"), itemList = {definition}}
	);
	
	player:TakeItem(itemTable);
end;

-- A function to take an item from a player's storage.
function Clockwork.storage:TakeFrom(player, itemTable)
	if (!player:GetStorageTable()) then return; end;

	local inventory = self:Query(player, "inventory");
	local players = {};
	
	if (!self:CanTakeFrom(player, itemTable)) then
		return;
	end;
	
	if (player:GiveItem(itemTable)) then
		Clockwork.inventory:RemoveInstance(inventory, itemTable);
		
		for k, v in ipairs(_player.GetAll()) do
			if (v:HasInitialized() and v:GetStorageTable()) then
				if (self:Query(v, "inventory") == inventory) then
					players[#players + 1] = v;
				end;
			end;
		end;
		
		Clockwork:StartDataStream(
			players, "StorageTake", Clockwork.item:GetSignature(itemTable)
		);
	end;
end;

-- A function to update storage for a player.
function Clockwork.storage:UpdateByID(player, uniqueID)
	if (!player:GetStorageTable()) then return; end;
	
	local inventory = self:Query(player, "inventory");
	local itemTable = Clockwork.item:FindByID(uniqueID);
	
	if (itemTable and inventory[uniqueID]) then
		local itemList = {};
		
		for k, v in pairs(inventory[uniqueID]) do
			local definition = Clockwork.item:GetDefinition(v, true);
			
			itemList[#itemList + 1] = {
				itemID = definition.itemID,
				data = definition.data
			};
		end;
		
		Clockwork:StartDataStream(player, "StorageGive", {index = itemTable("index"), itemList = itemList});
	end;
end;