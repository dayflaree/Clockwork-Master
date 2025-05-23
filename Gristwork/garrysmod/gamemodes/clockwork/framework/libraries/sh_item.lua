--[[
	� 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local Clockwork = Clockwork;
local setmetatable = setmetatable;
local tonumber = tonumber;
local IsValid = IsValid;
local pairs = pairs;
local type = type;
local string = string;
local util = util;
local os = os;

Clockwork.item = Clockwork.kernel:NewLibrary("Item");
Clockwork.item.stored = Clockwork.item.stored or {};
Clockwork.item.buffer = Clockwork.item.buffer or {};
Clockwork.item.weapons = Clockwork.item.weapons or {};
Clockwork.item.instances = Clockwork.item.instances or {};

--[[
	Begin defining the item class base for other item's to inherit from.
--]]

--[[ Set the __index meta function of the class. --]]
local CLASS_TABLE = {__index = CLASS_TABLE};

CLASS_TABLE.name = "Item Base";
CLASS_TABLE.skin = 0;
CLASS_TABLE.cost = 0;
CLASS_TABLE.batch = 5;
CLASS_TABLE.model = "models/error.mdl";
CLASS_TABLE.weight = 1;
CLASS_TABLE.space = 1;
CLASS_TABLE.itemID = 0;
CLASS_TABLE.business = false;
CLASS_TABLE.category = "Other";
CLASS_TABLE.description = "An item with no description.";

--[[
	Called when the item is invoked as a function.
	Whenever getting a value from an itemTable you
	should always do itemTable("varName") instead of
	itemTable.varName so that the query system is used.
	
	Note: it would be advised not to use itemTable("varName")
	during a query proxy or a stack overflow may be caused.
--]]
function CLASS_TABLE:__call(varName, failSafe)
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

	if (self.data[varName] != nil) then
		return self.data[varName];
	end;
	
	return (self[varName] != nil and self[varName] or failSafe);
end;

-- Called when the item is converted to a string.
function CLASS_TABLE:__tostring()
	return "ITEM["..self("itemID").."]";
end;

--[[
	A function to override an item's base data. This is
	just a nicer way to set a value to go along with
	the method of querying.
--]]
function CLASS_TABLE:Override(varName, value)
	self[varName] = value;
end;

-- A function to add data to an item.
function CLASS_TABLE:AddData(dataName, value, bNetworked)
	self.data[dataName] = value;
	self.defaultData[dataName] = value;
	self.networkData[dataName] = bNetworked;
end;

-- A function to remove data from an item.
function CLASS_TABLE:RemoveData(dataName)
	self.data[dataName] = nil;
	self.defaultData[dataName] = nil;
	self.networkData[dataName] = nil;
end;

-- A function to get whether an item has the same data as another.
function Clockwork.item:HasSameDataAs(itemTable)
    return Clockwork.kernel:AreTablesEqual(self.data, itemTable.data);
end;

-- A function to get whether the item is an instance.
function CLASS_TABLE:IsInstance()
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
function CLASS_TABLE:AddQueryProxy(varName, dataName, bNotDefault)
	self.queryProxies[varName] = {
		dataName = dataName,
		bNotDefault = bNotDefault
	};
end;

-- A function to remove a query proxy.
function CLASS_TABLE:RemoveQueryProxy(varName)
	self.queryProxies[varName] = nil;
end;

-- A function to get whether the item is based from another.
function CLASS_TABLE:IsBasedFrom(uniqueID)
	local itemTable = self;
	
	if (itemTable("unique") == uniqueID) then
		return true;
	end;

	while (itemTable and itemTable("baseItem")) do
		if (itemTable("baseItem") == uniqueID) then
			return true;
		end;
		
		itemTable = Clockwork.item:FindByID(
			itemTable("baseItem")
		);
	end;
	
	return false;
end;

-- A function to get a base class table from the item.
function CLASS_TABLE:GetBaseClass(uniqueID)
	return Clockwork.item:FindByID(uniqueID);
end;

-- A function to get whether the item can be ordered.
function CLASS_TABLE:CanBeOrdered()
	return (!self("isBaseItem") and self("business"));
end;

-- A function to get data from the item.
function CLASS_TABLE:GetData(dataName)
	return self.data[dataName];
end;

-- A function to get whether two items are the same.
function CLASS_TABLE:IsTheSameAs(itemTable)
	if (itemTable) then
		return (itemTable("uniqueID") == self("uniqueID")
		and itemTable("itemID") == self("itemID"));
	else
		return false;
	end;
end;

-- A function to get whether data is networked.
function CLASS_TABLE:IsDataNetworked(key)
	return (self.networkData[key] == true);
	
end;

-- A function to register a new item.
function CLASS_TABLE:Register()
	return Clockwork.item:Register(self);
end;

if (SERVER) then
	function CLASS_TABLE:SetData(dataName, value)
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
	function CLASS_TABLE:NetworkData()
		local timerName = "NetworkItem"..self("itemID");
		
		if (Clockwork.kernel:TimerExists(timerName)) then
			return;
		end;
		
		Clockwork.kernel:CreateTimer(timerName, 1, 1, function()
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
	local object = Clockwork.kernel:NewMetaTable(CLASS_TABLE);
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
	itemTable.index = Clockwork.kernel:GetShortCRC(itemTable.uniqueID);
	self.stored[itemTable.uniqueID] = itemTable;
	self.buffer[itemTable.index] = itemTable;
	
	if (itemTable.model) then
		util.PrecacheModel(itemTable.model);
		
		if (SERVER) then
			Clockwork.kernel:AddFile(itemTable.model);
		end;
	end;
	
	if (itemTable.attachmentModel) then
		util.PrecacheModel(itemTable.attachmentModel);
		
		if (SERVER) then
			Clockwork.kernel:AddFile(itemTable.attachmentModel);
		end;
	end;
	
	if (itemTable.replacement) then
		util.PrecacheModel(itemTable.replacement);
		
		if (SERVER) then
			Clockwork.kernel:AddFile(itemTable.replacement);
		end;
	end;
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

-- A function to get whether an item is ammo.
function Clockwork.item:IsAmmo(itemTable)
	if (itemTable and itemTable:IsBasedFrom("ammo_base")) then
		return true;
	end;
	
	return false;
end;

-- A function to get a weapon instance by its object.
function Clockwork.item:GetByWeapon(weapon)
	if (IsValid(weapon)) then
		local itemID = tonumber(weapon:GetNetworkedString("ItemID"));
		if (itemID and itemID != 0) then
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
			setmetatable(self.instances[itemID], CLASS_TABLE);
		end;
		
		if (data) then
			table.Merge(self.instances[itemID].data, data);
		end;
		
		if (self.instances[itemID].OnInstantiated) then
			self.instances[itemID]:OnInstantiated();
		end;
		
		return self.instances[itemID];
	end;
end;

--[[ Just to make sure we never ever get the same ID. --]]
local ITEM_INDEX = 0;

-- A function to generate an item ID.
function Clockwork.item:GenerateID()
	ITEM_INDEX = ITEM_INDEX + 1;
	return os.time() + ITEM_INDEX;
end;

-- A function to find an instance of an item.
function Clockwork.item:FindInstance(itemID)
	return self.instances[tonumber(itemID)];
end;

-- A function to get an item definition.
function Clockwork.item:GetDefinition(itemTable, bNetworkData)
	local definition = {
		itemID = itemTable("itemID"),
		index = itemTable("index"),
		data = {}
	};
	
	if (bNetworkData) then
		for k, v in pairs(itemTable("networkData")) do
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

function Clockwork.item:Initialize()
	local itemsTable = self:GetAll();

	for k, v in pairs(itemsTable) do
		if (v.baseItem and !self:Merge(v, v.baseItem)) then
			itemsTable[k] = nil;
		end;
	end;

	for k, v in pairs(itemsTable) do
		if (v.OnSetup) then v:OnSetup(); end;
		
		if (self:IsWeapon(v)) then
			self.weapons[v.weaponClass] = v;
		end;
		
		Clockwork.plugin:Call("ClockworkItemInitialized", v);
	end;
end;

if (SERVER) then
	Clockwork.item.entities = Clockwork.item.entities or {};
	
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
	
	--[[
		@codebase Server
		@details A function to send an item to a player.
	--]]
	function Clockwork.item:SendToPlayer(player, itemTable)
		if (itemTable) then
			Clockwork.datastream:Start(
				player, "ItemData", Clockwork.item:GetDefinition(itemTable, true)
			);
		end;
	end;
	
	--[[
		@codebase Server
		@details A function to send an item update to it's observers.
		@returns Table The table of observers.
	--]]
	function Clockwork.item:SendUpdate(itemTable, data)
		local info = {
			observers = {}, sendToAll = false
		};
			
		if (Clockwork.plugin:Call("ItemGetNetworkObservers", itemTable, info)
		or info.sendToAll) then
			info.observers = nil;
		end;
			
		Clockwork.datastream:Start(info.observers, "InvNetwork", {
			itemID = itemTable("itemID"),
			data = data
		});
			
		return info.observers;
	end;	
else
	function Clockwork.item:GetIconInfo(itemTable)
		local model = itemTable("iconModel", itemTable("model")) or "models/error.mdl";
		local skin = itemTable("iconSkin", itemTable("skin"));
		
		if (itemTable.GetClientSideModel) then
			model = itemTable:GetClientSideModel();
		end;
		
		if (itemTable.GetClientSideSkin) then
			skin = itemTable:GetClientSideSkin();
		end;
		
		if (!model) then
			model = "models/props_c17/oildrum001.mdl";
		end;
		
		return model, skin;
	end;
	
	-- A function to get an item's markup tooltip.
	function Clockwork.item:GetMarkupToolTip(itemTable, bBusinessStyle, Callback)
		local informationColor = Clockwork.option:GetColor("information");
		local description = itemTable("description");
		local toolTip = itemTable("toolTip");
		local weight = itemTable("weight").."kg";
		local space = itemTable("space").."l";
		local name = itemTable("name");
		
		local weightText = itemTable("weightText");

		if (weightText) then
			weight = weightText;
		elseif (itemTable("weight") == 0) then
			weight = "Weightless";
		end;
		
		local spaceText = itemTable("spaceText");

		if (spaceText) then
			space = spaceText;
		elseif (itemTable("space") == 0) then
			space = "Takes no space";
		end;

		if (bBusinessStyle) then
			local totalCost = itemTable("cost") * itemTable("batch");
			
			if (Clockwork.config:Get("cash_enabled"):Get()
			and totalCost != 0) then
				weight = Clockwork.kernel:FormatCash(totalCost);
			else
				weight = "Free";
			end;
		end;
		
		if (itemTable.GetClientSideName
		and itemTable:GetClientSideName()) then
			name = itemTable:GetClientSideName();
		end;
		
		if (bBusinessStyle and itemTable("batch") > 1) then
			name = itemTable("batch").." "..Clockwork.kernel:Pluralize(name);
		end;
		
		if (itemTable.GetClientSideInfo
		and itemTable:GetClientSideInfo()) then
			toolTip = itemTable:GetClientSideInfo();
		end;
		
		if (itemTable.GetClientSideDescription
		and itemTable:GetClientSideDescription()) then
			description = itemTable:GetClientSideDescription();
		end;
		
		local displayInfo = {
			itemTitle = nil,
			toolTip = toolTip,
			weight = weight,
			space = space,
			name = name
		};
		
		if (Callback) then
			Callback(displayInfo);
		end;
		
		local toolTipTitle = "";

		if (Clockwork.inventory:UseSpaceSystem()) then
			toolTipTitle = "["..displayInfo.name..", "..displayInfo.weight..", "..displayInfo.space.."]";
		else
			toolTipTitle = "["..displayInfo.name..", "..displayInfo.weight.."]";
		end
		
		if (displayInfo.itemTitle) then
			toolTipTitle = displayInfo.itemTitle;
		end;
		
		if (itemTable("color")) then
			toolTipTitle = Clockwork.kernel:MarkupTextWithColor(toolTipTitle, itemTable("color"));
		else
			toolTipTitle = Clockwork.kernel:MarkupTextWithColor(toolTipTitle, informationColor);
		end;
		
		if (displayInfo.toolTip) then
			if (itemTable("color")) then
				displayInfo.toolTip = Clockwork.kernel:MarkupTextWithColor("[Information]", itemTable("color")).."\n"..displayInfo.toolTip;
			else
				displayInfo.toolTip = Clockwork.kernel:MarkupTextWithColor("[Information]", informationColor).."\n"..displayInfo.toolTip;
			end;
			
			toolTipTitle = toolTipTitle.."\n"..Clockwork.config:Parse(description).."\n"..Clockwork.config:Parse(displayInfo.toolTip);
		else
			toolTipTitle = toolTipTitle.."\n"..Clockwork.config:Parse(description);
		end;
		
		toolTipTitle = toolTipTitle.."\n"..Clockwork.kernel:MarkupTextWithColor("[Category]", informationColor);
		toolTipTitle = toolTipTitle.."\n"..itemTable("category");
		
		return toolTipTitle;
	end;
	
	Clockwork.datastream:Hook("ItemData", function(data)
		Clockwork.item:CreateInstance(
			data.index, data.itemID, data.data
		);
	end);
end;