--[[
	Free Clockwork!
--]]

Clockwork.inventory = Clockwork:NewLibrary("Inventory");

-- A function to make an inventory loadable.
function Clockwork.inventory:ToLoadable(inventory)
	local newTable = {};

	for k, v in pairs(inventory) do
		local itemTable = Clockwork.item:FindByID(k);
		
		if (itemTable) then
			local uniqueID = itemTable("uniqueID");
			
			if (!newTable[uniqueID]) then
				newTable[uniqueID] = {};
			end;
			
			for k2, v2 in pairs(v) do
				local itemID = tonumber(k2);
				local foundID = Clockwork.item:FindInstance(itemID);
				if (!foundID) then
					local instance = Clockwork.item:CreateInstance(
						k, itemID, v2
					);
					
					if (instance and !instance.OnLoaded
					or instance:OnLoaded() != false) then
						newTable[k][itemID] = instance;
					end;
				else
					newTable[k][itemID] = foundID;
				end;
			end;
		end;
	end;
	
	return newTable;
end;

-- A function to make an inventory saveable.
function Clockwork.inventory:ToSaveable(inventory)
	local newTable = {};
	
	for k, v in pairs(inventory) do
		local itemTable = Clockwork.item:FindByID(k);
		
		if (itemTable) then
			local defaultData = itemTable("defaultData");
			local uniqueID = itemTable("uniqueID");
			
			if (!newTable[uniqueID]) then
				newTable[uniqueID] = {};
			end;
			
			for k2, v2 in pairs(v) do
				local newData = {};
				local itemID = tostring(k2);
				
				if (v2["data"]) then
					for k3, v3 in pairs(v2["data"]) do
						if (defaultData[k3] != v3) then
							newData[k3] = v3;
						end;
					end;
				end;
				
				if (!v2.OnSaved or v2:OnSaved(newData) != false) then
					newTable[uniqueID][itemID] = newData;
				end;
			end;
		end
	end;
	
	return newTable;
end;

-- A function to get an inventory as an items list.
function Clockwork.inventory:GetAsItemsList(inventory)
	local itemsList = {};
		for k, v in pairs(inventory) do
			local itemTable = v;
			table.Add(itemsList, itemTable);
		end;
	return itemsList;
end;

-- A function to calculate the weight of an inventory.
function Clockwork.inventory:CalculateWeight(inventory)
	local weight = 0;
	
	for k, v in pairs(inventory) do
		local itemTable = Clockwork.item:FindByID(k);
		
		if (itemTable and itemTable("weight")) then
			weight = weight + (itemTable("weight") * table.Count(v));
		end;
	end;
	
	return weight;
end;

-- A function to get whether an inventory is empty.
function Clockwork.inventory:IsEmpty(inventory)
	if (!inventory) then return true; end;
	local bEmpty = true;
	
	for k, v in pairs(inventory) do
		if (table.Count(v) > 0) then
			return false;
		end;
	end;
	
	return true;
end;

-- A function to add an instance to a table.
function Clockwork.inventory:AddInstance(inventory, itemTable)
	if (!inventory[itemTable("uniqueID")]) then
		inventory[itemTable("uniqueID")] = {};
	end;
	
	inventory[itemTable("uniqueID")][itemTable("itemID")] = itemTable;
end;

-- A function to remove an instance from a table.
function Clockwork.inventory:RemoveInstance(inventory, itemTable)
	if (inventory[itemTable("uniqueID")]) then
		inventory[itemTable("uniqueID")][itemTable("itemID")] = nil;
		return Clockwork.item:FindInstance(itemTable("itemID"));
	end;
end;

-- A function to remove a uniquen ID from a table.
function Clockwork.inventory:RemoveUniqueID(inventory, uniqueID, itemID)
	local itemTable = Clockwork.item:FindByID(uniqueID);
	if (itemID) then itemID = tonumber(itemID); end;
	
	if (itemTable and inventory[itemTable("uniqueID")]) then
		if (!itemID) then
			local firstValue = table.GetFirstValue(inventory[itemTable("uniqueID")]);
			
			if (firstValue) then
				inventory[itemTable("uniqueID")][firstValue.itemID] = nil;
				return Clockwork.item:FindInstance(firstValue.itemID);
			end;
		else
			inventory[itemTable("uniqueID")][itemID] = nil;
		end;
	end;
end;

-- A function to find an item within an inventory.
function Clockwork.inventory:FindItemByID(inventory, uniqueID, itemID)
	local itemTable = Clockwork.item:FindByID(uniqueID);
	if (itemID) then itemID = tonumber(itemID); end;
	
	if (!itemTable or !inventory[itemTable("uniqueID")]) then
		return;
	end;
	
	if (itemID) then
		if (inventory[itemTable("uniqueID")]) then
			return inventory[itemTable("uniqueID")][itemID];
		end;
	else
		local firstValue = table.GetFirstValue(inventory[itemTable("uniqueID")]);
		
		if (firstValue) then
			return inventory[itemTable("uniqueID")][firstValue.itemID];
		end;
	end;
end;

-- A function to get an inventory's items by unique ID.
function Clockwork.inventory:GetItemsByID(inventory, uniqueID)
	local itemsTable = Clockwork.item:FindByID(uniqueID);
	local itemList = {};
	if (itemsTable) then
		return inventory[itemsTable["uniqueID"]];
	else
		return {};
	end;
end;

-- A function to get whether an inventory has an item by ID.
function Clockwork.inventory:HasItemByID(inventory, uniqueID)
	local itemTable = Clockwork.item:FindByID(uniqueID);
	return (inventory[itemTable("uniqueID")] and table.Count(inventory[itemTable("uniqueID")]) > 0);
end;

-- A function to get the count of an item by ID
function Clockwork.inventory:CountByID(inventory, uniqueID)
	local itemTable = Clockwork.item:FindByID(uniqueID);
	if (self:HasItemByID(inventory, uniqueID)) then
		return table.Count(inventory[itemTable("uniqueID")]);
	end;
	return 0;
end;

-- A function to get whether an inventory item instance.
function Clockwork.inventory:HasItemInstance(inventory, itemTable)
	local uniqueID = itemTable("uniqueID");
	return (inventory[uniqueID] and inventory[uniqueID][itemTable("itemID")] != nil);
end;

-- A function to create a duplicate of an inventory.
function Clockwork.inventory:CreateDuplicate(inventory)
	local duplicate = {};
		for k, v in pairs(inventory) do
			duplicate[k] = {};
			for k2, v2 in pairs(v) do
				duplicate[k][k2] = v2;
			end;
		end;
	return duplicate;
end;

if (SERVER) then
	function Clockwork.inventory:SendUpdateByInstance(player, itemTable)
		if (itemTable) then
			Clockwork:StartDataStream(
				player, "InvUpdate", {Clockwork.item:GetDefinition(itemTable, true)}
			);
		end;
	end;
	
	-- A function to send all inventory updates to a player.
	function Clockwork.inventory:SendUpdateAll(player)
		local inventory = player:GetInventory();
		
		for k, v in pairs(inventory) do
			self:SendUpdateByID(player, k);
		end;
	end;
	
	-- A function to send an inventory update by ID.
	function Clockwork.inventory:SendUpdateByID(player, uniqueID)
		local itemTables = self:GetItemsByID(player:GetInventory(), uniqueID);
		
		if (itemTables) then
			local definitions = {};
			
			for k, v in pairs(itemTables) do
				v = Clockwork.item:FindInstance(k);
				definitions[#definitions + 1] = Clockwork.item:GetDefinition(v, true);
			end;
			
			Clockwork:StartDataStream(player, "InvUpdate", definitions);
		end;
	end;
	
	-- A function to rebuild a player's inventory.
	function Clockwork.inventory:Rebuild(player)
		Clockwork:OnNextFrame("RebuildInv"..player:UniqueID(), function()
			if (IsValid(player)) then
				umsg.Start("cwInvRebuild", player);
				umsg.End();
			end;
		end);
	end;
else
	Clockwork.inventory.client = {};
	
	-- A function to get the inventory panel.
	function Clockwork.inventory:GetPanel()
		return self.panel;
	end;
	
	-- A function to rebuild the local player's inventory.
	function Clockwork.inventory:Rebuild()
		if (Clockwork.menu:IsPanelActive(self:GetPanel())) then
			Clockwork:OnNextFrame("RebuildInv", function()
				if (IsValid(self:GetPanel())) then
					self:GetPanel():Rebuild();
				end;
			end);
		end;
	end;
	
	-- A function to get the local player's inventory.
	function Clockwork.inventory:GetClient()
		return self.client;
	end;
	
	usermessage.Hook("cwInvClear", function(msg)
		Clockwork.inventory.client = {};
		Clockwork.inventory:Rebuild();
	end);
	
	usermessage.Hook("cwInvRebuild", function(msg)
		Clockwork.inventory:Rebuild();
	end);
	
	Clockwork:HookDataStream("InvNetwork", function(data)
		local itemTable = Clockwork.item:FindInstance(data.itemID);
		
		if (itemTable) then
			table.Merge(itemTable("data"), data.data);
			Clockwork.plugin:Call("ItemNetworkDataUpdated", itemTable);
		end;
	end);
	
	Clockwork:HookDataStream("InvTake", function(data)
		local itemTable = Clockwork.inventory:FindItemByID(
			Clockwork.inventory.client, data[1], data[2]
		);
		
		if (itemTable) then
			Clockwork.inventory:RemoveInstance(
				Clockwork.inventory.client, itemTable
			);
			
			Clockwork.inventory:Rebuild();
			Clockwork.plugin:Call("PlayerItemTaken", itemTable);
		end;
	end);

	Clockwork:HookDataStream("InvGive", function(data)
		local itemTable = Clockwork.item:CreateInstance(
			data.index, data.itemID, data.data
		);
		
		Clockwork.inventory:AddInstance(
			Clockwork.inventory.client, itemTable
		);
		
		Clockwork.inventory:Rebuild();
		Clockwork.plugin:Call("PlayerItemGiven", itemTable);
	end);
	
	Clockwork:HookDataStream("InvUpdate", function(data)
		for k, v in ipairs(data) do
			local itemTable = Clockwork.item:CreateInstance(
				v.index, v.itemID, v.data
			);
			
			Clockwork.inventory:AddInstance(
				Clockwork.inventory.client, itemTable
			);
		end;
		
		Clockwork.inventory:Rebuild();
	end);
end;