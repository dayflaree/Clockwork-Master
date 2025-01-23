--[[
	Free Clockwork!
--]]

Clockwork.item = Clockwork:NewLibrary("Item");
Clockwork.item.class = {};
Clockwork.item.stored = {};
Clockwork.item.buffer = {};
Clockwork.item.weapons = {};
Clockwork.item.instances = {};

--[[
	Begin defining the item class base for other item's to inherit from.
--]]

Clockwork.item.class.name = "Item Base";
Clockwork.item.class.skin = 0;
Clockwork.item.class.cost = 0;
Clockwork.item.class.batch = 5;
Clockwork.item.class.model = "models/error.mdl";
Clockwork.item.class.weight = 1;
Clockwork.item.class.itemID = 0;
Clockwork.item.class.business = false;
Clockwork.item.class.category = "Other";
Clockwork.item.class.description = "An item with no description.";

--[[
	Called when the item is invoked as a function.
	Whenever getting a value from an itemTable you
	should always do itemTable("varName") instead of
	itemTable.varName so that the query system is used.
	
	Note: it would be advised not to use itemTable("varName")
	during a query proxy or a stack overflow may be caused.
--]]
function Clockwork.item.class:__call(varName, failSafe)
	if (self.queryProxies[varName]) then
		local bNotDefault = self.queryProxies[varName].bNotDefault;
		local dataName = self.queryProxies[varName].dataName;
		
		if (type(dataName) != "function") then
			local defaultValue = self.defaultData[dataName];
			local currentValue = self.data[dataName];
			
			if (defaultValue != nil and currentValue != nil
			and (defaultValue != currentValue or !bNotDefault)) then
				return self.data[dataName];
			end;
		else
			local returnValue = dataName(self);
			if (returnValue != nil) then
				return returnValue;
			end;
		end;
	end;
	
	return (self[varName] != nil and self[varName] or failSafe);
end;

-- Called when the item is converted to a string.
function Clockwork.item.class__tostring()
	return "ITEM["..self("itemID").."]";
end;

--[[
	A function to override an item's base data. This is
	just a nicer way to set a value to go along with
	the method of querying.
--]]
function Clockwork.item.class:Override(varName, value)
	self[varName] = value;
end;

-- A function to add data to an item.
function Clockwork.item.class:AddData(dataName, value, bNetworked)
	self.data[dataName] = value;
	self.defaultData[dataName] = value;
	self.networkData[dataName] = bNetworked;
end;

-- A function to remove data from an item.
function Clockwork.item.class:RemoveData(dataName)
	self.data[dataName] = nil;
	self.defaultData[dataName] = nil;
	self.networkData[dataName] = nil;
end;

-- A function to get whether the item is an instance.
function Clockwork.item.class:IsInstance()
	return (self("itemID") != 0);
end;

--[[
	A function to add a query proxy. This allows us
	to replace any queries for a variable name with
	the data variable value of our choice.
	
	Note: if a function is supplied for the dataName
	then the value that the function returns will be
	used.
	
	bNotDefault does not apply when using callbacks,
	but otherwise will only replace the query if the
	data variable is different from its default value.
--]]
function Clockwork.item.class:AddQueryProxy(varName, dataName, bNotDefault)
	self.queryProxies[varName] = {
		dataName = dataName,
		bNotDefault = bNotDefault
	};
end;

-- A function to remove a query proxy.
function Clockwork.item.class:RemoveQueryProxy(varName)
	self.queryProxies[varName] = nil;
end;

-- A function to get whether the item is based from another.
function Clockwork.item.class:IsBasedFrom(uniqueID)
	local itemTable = self;

	while (itemTable and itemTable("baseItem")) do
		if (itemTable("baseItem") == uniqueID) then
			return true;
		end;
		
		itemTable = Clockwork.item:FindByID(
			itemTable("baseItem")
		);
	end;
end;

-- A function to get a base class table from the item.
function Clockwork.item.class:GetBaseClass(uniqueID)
	return Clockwork.item:FindByID(uniqueID);
end;

-- A function to get whether the item can be ordered.
function Clockwork.item.class:CanBeOrdered()
	return (!self("isBaseItem") and self("business"));
end;

-- A function to get data from the item.
function Clockwork.item.class:GetData(dataName)
	return self.data[dataName];
end;

-- A function to get whether two items are the same.
function Clockwork.item.class:IsTheSameAs(itemTable)
	if (itemTable) then
		return (itemTable("uniqueID") == self("uniqueID")
		and itemTable("itemID") == self("itemID"));
	else
		return false;
	end;
end;

-- A function to get whether data is networked.
function Clockwork.item.class:IsDataNetworked(key)
	return (self.networkData[key] == true);
end;

if (SERVER) then
	function Clockwork.item.class:SetData(dataName, value)
		if (self:IsInstance() and self.data[dataName] != nil
		and self.data[dataName] != value) then
			self.data[dataName] = value;
			
			if (self:IsDataNetworked(dataName)) then
				self.networkQueue[dataName] = value;
				self:NetworkData();
			end;
		end;
	end;

	-- A function to network the item data.
	function Clockwork.item.class:NetworkData()
		local timerName = "NetworkItem"..self("itemID");
		
		if (Clockwork:TimerExists(timerName)) then
			return;
		end;
		
		Clockwork:CreateTimer(timerName, 1, 1, function()
			Clockwork.item:SendUpdate(
				self, self.networkQueue
			);
			self.networkQueue = {};
		end);
	end;
end;

--[[
	End defining the base item class and begin defining
	the item utility functions.
--]]

-- A function to get the item buffer.
function Clockwork.item:GetBuffer()
	return self.buffer;
end;

-- A function to get all items.
function Clockwork.item:GetAll()
	return self.stored;
end;

-- A function to get a new item.
function Clockwork.item:New(baseItem, bIsBaseItem)
	local object = Clockwork:NewMetaTable(self.class);
		object.networkQueue = {};
		object.networkData = {};
		object.defaultData = {};
		object.queryProxies = {};
		object.isBaseItem = bIsBaseItem;
		object.baseItem = baseItem;
		object.data = {};
	return object;
end;

-- A function to register a new item.
function Clockwork.item:Register(itemTable)
	itemTable.uniqueID = string.lower(string.gsub(itemTable.uniqueID or string.gsub(itemTable.name, "%s", "_"), "['%.]", ""));
	itemTable.index = Clockwork:GetShortCRC(itemTable.uniqueID);
	self.stored[itemTable.uniqueID] = itemTable;
	self.buffer[itemTable.index] = itemTable;
end;

-- A function to create a copy of an item instance.
function Clockwork.item:CreateCopy(itemTable)
	return Clockwork.item:CreateInstance(
		itemTable("uniqueID"), nil, itemTable("data")
	);
end;

-- A function to get whether an item is a weapon.
function Clockwork.item:IsWeapon(itemTable)
	if (itemTable and itemTable:IsBasedFrom("weapon_base")) then
		return true;
	end;
	
	return false;
end;

-- A function to get a weapon instance by its object.
function Clockwork.item:GetByWeapon(weapon)
	if (IsValid(weapon)) then
		local itemID = weapon:GetNetworkedInt("ItemID");
		if (itemID != 0) then
			return self:FindInstance(itemID);
		end;
	end;
end;

-- A function to create an instance of an item.
function Clockwork.item:CreateInstance(uniqueID, itemID, data)
	local itemTable = Clockwork.item:FindByID(uniqueID);
	if (itemID) then itemID = tonumber(itemID); end;
	
	if (itemTable) then
		if (!itemID) then
			itemID = self:GenerateID();
		end;
		
		if (!self.instances[itemID]) then
			self.instances[itemID] = table.Copy(itemTable);
			self.instances[itemID].itemID = itemID;
		end;
		
		if (data) then
			table.Merge(self.instances[itemID].data, data);
		end;
		
		return self.instances[itemID];
	end;
end;

-- A function to generate an item ID.
function Clockwork.item:GenerateID()
	local unixTime = tostring(os.time());
	local curTime = tostring(CurTime());
	
	//return (os.time() + math.Round(math.Rand(0, 0.99), 3));
	
	return Clockwork:GetShortCRC(
		unixTime..curTime..tostring(math.random(1, 999))
	);
end;

-- A function to find an instance of an item.
function Clockwork.item:FindInstance(itemID)
	return self.instances[tonumber(itemID)];
end;

-- A function to get an item definition.
function Clockwork.item:GetDefinition(itemTable, bNetworkData)
	local definition = {
		itemID = itemTable["itemID"],
		index = itemTable["index"],
		data = {}
	};
	
	if (bNetworkData) then
		for k, v in pairs(itemTable.networkData) do
			definition.data[k] = itemTable:GetData(k);
		end;
	end;
	
	return definition;
end;

-- A function to get an item signature.
function Clockwork.item:GetSignature(itemTable)
	return {uniqueID = itemTable("uniqueID"), itemID = itemTable("itemID")};
end;

-- A function to get an item by its name.
function Clockwork.item:FindByID(identifier)
	if (identifier and identifier != 0 and type(identifier) != "boolean") then
		if (self.buffer[identifier]) then
			return self.buffer[identifier];
		elseif (self.stored[identifier]) then
			return self.stored[identifier];
		elseif (self.weapons[identifier]) then
			return self.weapons[identifier];
		end;
		
		local lowerName = string.lower(identifier);
		local itemTable = nil;
		
		for k, v in pairs(self.stored) do
			local itemName = v("name");
			
			if (string.find(string.lower(itemName), lowerName)
			and (!itemTable or string.len(itemName) < string.len(itemTable("name")))) then
				itemTable = v;
			end;
		end;
		
		return itemTable;
	end;
end;

-- A function to merge an item with a base item.
function Clockwork.item:Merge(itemTable, baseItem, bTemporary)
	local baseTable = self:FindByID(baseItem);
	local isBaseItem = itemTable("isBaseItem");
	
	if (baseTable and baseTable != itemTable) then
		local baseTableCopy = table.Copy(baseTable);
		
		if (baseTableCopy.baseItem) then
			baseTableCopy = self:Merge(
				baseTableCopy,
				baseTableCopy.baseItem,
				true
			);
			
			if (!baseTableCopy) then
				return;
			end;
		end;
		
		table.Merge(baseTableCopy, itemTable);
		
		if (!bTemporary) then
			baseTableCopy.baseClass = baseTable;
			baseTableCopy.isBaseItem = isBaseItem;
			self:Register(baseTableCopy);
		end;
		
		return baseTableCopy;
	end;
end;

if (SERVER) then
	Clockwork.item.entities = {};
	
	-- A function to use an item for a player.
	function Clockwork.item:Use(player, itemTable, bNoSound)
		local itemEntity = player:GetItemEntity();
		
		if (player:HasItemInstance(itemTable)) then
			if (itemTable.OnUse) then
				if (itemEntity and itemEntity.cwItemTable == itemTable) then
					player:SetItemEntity(nil);
				end;
				
				local onUse = itemTable:OnUse(player, itemEntity);
				
				if (onUse == nil) then
					player:TakeItem(itemTable);
				elseif (onUse == false) then
					return false;
				end;
				
				if (!bNoSound) then
					local useSound = itemTable("useSound");
					
					if (useSound) then
						if (type(useSound) == "table") then
							player:EmitSound(useSound[math.random(1, #useSound)]);
						else
							player:EmitSound(useSound);
						end;
					elseif (useSound != false) then
						player:EmitSound("items/battery_pickup.wav");
					end;
				end;
				
				Clockwork.plugin:Call("PlayerUseItem", player, itemTable, itemEntity);
				
				return true;
			end;
		end;
	end;
	
	-- A function to drop an item from a player.
	function Clockwork.item:Drop(player, itemTable, position, bNoSound, bNoTake)
		if (itemTable and (bNoTake or player:HasItemInstance(itemTable))) then
			local traceLine = nil;
			local entity = nil;
			
			if (itemTable.OnDrop) then
				if (!position) then
					traceLine = player:GetEyeTraceNoCursor();
					position = traceLine.HitPos
				end;
				
				if (itemTable:OnDrop(player, position) == false) then
					return false;
				end;
				
				if (!bNoTake) then
					player:TakeItem(itemTable);
				end;
				
				if (itemTable.OnCreateDropEntity) then
					entity = itemTable:OnCreateDropEntity(player, position);
				end;
				
				if (!IsValid(entity)) then
					entity = Clockwork.entity:CreateItem(player, itemTable, position);
				end;
				
				if (IsValid(entity)) then
					if (traceLine and traceLine.HitNormal) then
						Clockwork.entity:MakeFlushToGround(entity, position, traceLine.HitNormal);
					end;
				end;
				
				if (!bNoSound) then
					local dropSound = itemTable("dropSound");
					
					if (dropSound) then
						if (type(dropSound) == "table") then
							player:EmitSound(dropSound[math.random(1, #dropSound)]);
						else
							player:EmitSound(dropSound);
						end;
					elseif (dropSound != false) then
						player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
					end;
				end;
				
				Clockwork.plugin:Call("PlayerDropItem", player, itemTable, position, entity);
				
				return true;
			end;
		end;
	end;
	
	-- A function to destroy a player's item.
	function Clockwork.item:Destroy(player, itemTable, bNoSound)
		if (player:HasItemInstance(itemTable) and itemTable.OnDestroy) then
			if (itemTable:OnDestroy(player) == false) then
				return false;
			end;
			
			player:TakeItem(itemTable);
			
			if (!bNoSound) then
				local destroySound = itemTable("destroySound");
				
				if (destroySound) then
					if (type(destroySound) == "table") then
						player:EmitSound(destroySound[math.random(1, #destroySound)]);
					else
						player:EmitSound(destroySound);
					end;
				elseif (destroySound != false) then
					player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
				end;
			end;
			
			Clockwork.plugin:Call("PlayerDestroyItem", player, itemTable);
			
			return true;
		end;
	end;
	
	-- A function to remove an item entity.
	function Clockwork.item:RemoveItemEntity(entity)
		local itemTable = entity:GetItemTable();
		self.entities[itemTable("itemID")] = nil;
	end;
	
	-- A function to add an item entity.
	function Clockwork.item:AddItemEntity(entity, itemTable)
		self.entities[itemTable("itemID")] = entity;
	end;
	
	-- A function to find an entity by an instance.
	function Clockwork.item:FindEntityByInstance(itemTable)
		local entity = self.entities[itemTable("itemID")];
		
		if (IsValid(entity)) then
			return entity;
		end;
	end;
	
	-- A function to send an item to a player.
	function Clockwork.item:SendToPlayer(player, itemTable)
		if (itemTable) then
			Clockwork:StartDataStream(
				player, "ItemData", Clockwork.item:GetDefinition(itemTable, true)
			);
		end;
	end;
	
	-- A function to send an item update to it's observers.
	function Clockwork.item:SendUpdate(itemTable, data)
		local info = {
			observers = {}, sendToAll = false
		};
		
		if (Clockwork.plugin:Call("ItemGetNetworkObservers", itemTable, info)
		or info.sendToAll) then
			info.observers = nil;
		end;
		
		Clockwork:StartDataStream(info.observers, "InvNetwork", {
			itemID = itemTable("itemID"),
			data = data
		});
		
		return info.observers;
	end;
else
	function Clockwork.item:GetIconInfo(itemTable)
		local model = itemTable("iconModel", itemTable("model"));
		local skin = itemTable("iconSkin", itemTable("skin"));
		
		if (itemTable.GetClientSideModel) then
			model = itemTable:GetClientSideModel();
		end;
		
		if (itemTable.GetClientSideSkin) then
			skin = itemTable:GetClientSideSkin();
		end;
		
		return model, skin;
	end;
	
	-- A function to get an item's markup tooltip.
	function Clockwork.item:GetMarkupToolTip(itemTable, bBusinessStyle)
		local informationColor = Clockwork.option:GetColor("information");
		local description = itemTable("description");
		local toolTip = itemTable("toolTip");
		local weight = itemTable("weight").."kg";
		local name = itemTable("name");
		
		if (itemTable("weightText")) then
			weight = itemTable("weightText");
		elseif (itemTable("weight") == 0) then
			weight = "Weightless";
		end;
		
		if (bBusinessStyle) then
			local totalCost = itemTable("cost") * itemTable("batch");
			
			if (totalCost != 0) then
				weight = FORMAT_CASH(totalCost);
			else
				weight = "Free";
			end;
		end;
		
		if (itemTable.GetClientSideName
		and itemTable:GetClientSideName()) then
			name = itemTable:GetClientSideName();
		end;
		
		if (bBusinessStyle and itemTable("batch") > 1) then
			name = itemTable("batch").." "..Clockwork:Pluralize(name);
		end;
		
		if (itemTable.GetClientSideInfo
		and itemTable:GetClientSideInfo()) then
			toolTip = itemTable:GetClientSideInfo();
		end;
		
		if (itemTable.GetClientSideDescription
		and itemTable:GetClientSideDescription()) then
			description = itemTable:GetClientSideDescription();
		end;
		
		local toolTipTitle = "["..name..", "..weight.."]";
		
		if (itemTable("color")) then
			toolTipTitle = Clockwork:MarkupTextWithColor(toolTipTitle, itemTable("color"));
		else
			toolTipTitle = Clockwork:MarkupTextWithColor(toolTipTitle, informationColor);
		end;
		
		if (toolTip) then
			toolTip = Clockwork:MarkupTextWithColor("[Information]", informationColor).."\n"..toolTip;
			toolTipTitle = toolTipTitle.."\n"..Clockwork.config:Parse(description).."\n"..Clockwork.config:Parse(toolTip);
		else
			toolTipTitle = toolTipTitle.."\n"..Clockwork.config:Parse(description);
		end;
		
		toolTipTitle = toolTipTitle.."\n"..Clockwork:MarkupTextWithColor("[Category]", informationColor);
		toolTipTitle = toolTipTitle.."\n"..itemTable("category");
		
		return toolTipTitle;
	end;
	
	Clockwork:HookDataStream("ItemData", function(data)
		Clockwork.item:CreateInstance(
			data.index, data.itemID, data.data
		);
	end);
end;