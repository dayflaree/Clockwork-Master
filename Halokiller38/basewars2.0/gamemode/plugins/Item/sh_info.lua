--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

PLUGIN.name = "Item";

RP.Item = {};

RP.Item.database = {};
RP.Item.entities = {};
RP.Item.items = {};


function PLUGIN:Init()
	RP.Item:IncludeItems();
end;

function RP.Item:IncludeItems()
	RP:IncludeDirectory("items/", true);
	
	for k, data in pairs(RP.Item.database) do
		if (data.derive and data.isBaseItem) then
			local data = table.Merge(RP.Item:Get(data.derive), data);
			if (data) then
				RP.Item.database[k] = data;
			end;
		end
		RP.Item.database[k].saveData = {};
	end;
	
	
	for k, data in pairs(RP.Item.database) do
		if (data.derive) then
			local data = table.Merge(RP.Item:Get(data.derive), data);
			if (data) then
				RP.Item.database[k] = data;
			end;
		end
		RP.Item.database[k].saveData = {};
	end;
	
end;

function RP.Item:New(data)
	if (!data.uniqueID) then
		data.uniqueID = string.lower(string.gsub(data.name, " ", "_"));
	end;
	
	self.database[data.uniqueID] = data;
end;

	
function RP.Item:GenerateID()
	local unixTime = tostring(os.time());
	local curTime = tostring(CurTime());
	
	return tostring(math.ceil(util.CRC(unixTime..curTime..tostring(math.random(1, 99998))) / 100002));
end;

function RP.Item:Get(id)
	local returnVar = false;
	if (type(id) == "string" and !tonumber(id)) then
		if (self.database[id]) then
			returnVar = table.Copy(self.database[id]);
		end;
	end;
	
	if (type(tonumber(id)) == "number") then
		local itemData = self.items[id];
		
		if (itemData) then
			returnVar = itemData;
		end;
	end;
	
	return returnVar;
end;

function RP.Item:GetWeapon(weapon)
	if (IsValid(weapon)) then
		local itemID = weapon:GetNWString("ItemID");
		if (itemID) then
			return self:Get(itemID);
		end;
	end;
	return false;
end;


if (SERVER) then

	function RP.Item:InsertID(itemID, base, data)
		itemID = tostring(itemID);
		self.items[itemID] = self:Get(base);
		self.items[itemID].saveData = data or {};
		self.items[itemID].base = base;
		
		table.Merge(self.items[itemID], data);
		
		self.items[itemID].itemID = itemID;
	end;

	function RP.Item:CreateID(base, data)
		if (type(base) != "string") then
			return false;
		end;
		
		local itemID = self:GenerateID();

		if (self:Get(base)) then
			self.items[itemID] = self:Get(base);
			self.items[itemID].base = base;
		end;
		
		if (data and type(data) == "table") then
			table.Merge(self.items[itemID], data);
			self.items[itemID].saveData = data;
		end;
		
		self.items[itemID].itemID = itemID;
		
		return itemID;
	end;

	function RP.Item:DataID(itemID, data)
		if (self.items[itemID]) then
			table.Merge(self.items[itemID], data);
			table.Merge(self.items[itemID].saveData, data);
			return itemID;
		end;

		return false;
	end;

	function RP.Item:RemoveID(itemID)
		self.items[itemID] = nil;
	end;
	
	function RP.Item:CreateEntity(player, itemID, position)
		local itemStruct = ents.Create("rp_item");
		itemStruct:SetItemID(itemID);
		itemStruct:SetPos(position);
		itemStruct:Spawn();
		itemStruct:Activate();
		itemStruct:DropToFloor();
		self.entities[itemID] = itemStruct;
		if (itemStruct) then
			return itemStruct;
		end;
	end;
	
	function RP.Item:SendItemData(player, itemID)
		if (self:Get(itemID)) then
			local itemTable = self:Get(itemID);
			RP:DataStream(player, "ItemData", {itemID = itemID, base = itemTable.base, data = itemTable.saveData});
		end;
	end;
	
	RP:DataHook("RequestItem", function(player, data)
		if (data.itemID) then
			RP.Item:SendItemData(player, data.itemID);
		end;
	end);		
	
else
	
	function RP.Item:InsertData(itemID, base, data)
		if (self:Get(base).derive) then
			self.items[itemID] = table.Merge(self:Get(self:Get(base).derive), self:Get(base));
		else
			self.items[itemID] = self:Get(base);
		end;
		self.items[itemID].base = base;
		table.Merge(self.items[itemID], data);
		self.items[itemID].itemID = itemID;
	end;
	
	//Have this on the clientside so we can do some edits to display data.. cut down on netwokring.
	function RP.Item:DataID(itemID, data)
		if (self.items[itemID]) then
			table.Merge(self.items[itemID], data);
			return itemID;
		end;
		return false;
	end;	
	
	function RP.Item:RequestData(itemID)
		RP:DataStream("RequestItem", {itemID = itemID});
	end;
	
	RP:DataHook("ItemData", function(data)
		if (data.itemID) then
			RP.Item:InsertData(data.itemID, data.base, data.data);
		end;
	end);
end;

//Default item base goes here :(
local ITEM = {};
ITEM.uniqueID = "item_base";
ITEM.isBaseItem = true;
ITEM.name = "Generic Item";
ITEM.category = "Items";
ITEM.model = "models/props_phx/misc/potato.mdl";
ITEM.weight = 1;

function ITEM:OnDrop(player)
	return true;
end;

function ITEM:OnUse(player)
	return true;
end;

function ITEM:Description(descMeta)
	
	descMeta:Color(Color(50, 200, 0)); descMeta:Text("Category: "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(self.category);
	descMeta:NewLine(); descMeta:Color(Color(50, 200, 0)); descMeta:Text("Weight: "); descMeta:Color(Color(255, 255, 255)); descMeta:Text(self.weight.."kg");	
	descMeta:HorizontalRule();
	
	descMeta:Color(Color(255, 255, 255));
	if (type(self.CustomDesc) == "function") then
		self:CustomDesc(descMeta);
	end;
	
	return descMeta:Get();
end;

function ITEM:RemoveInventory(player)
	print(player:Name().." "..self.itemID);
	RP.Inventory:TakeItem(player, self.itemID);
end;

function ITEM:OnPurchase(player, trace)
	return true;
end;

function ITEM:CanPurchase(player)
	return true;
end;

RP.Item:New(ITEM);