RP.item = {};

RP.item.database = {};
RP.item.entities = {};
RP.item.items = {};

function RP.item:New(data)
	if (!data.uniqueID) then
		data.uniqueID = string.lower(string.gsub(data.name, " ", "_"));
	end;
	
	if (data.derive) then
		data = table.Merge(self:Get(data.derive), data);
	end;
	
	self.database[data.uniqueID] = data;
	self.database[data.uniqueID].saveData = {};
end;

	
function RP.item:GenerateID()
	local unixTime = tostring(os.time());
	local curTime = tostring(CurTime());
	
	return tostring(math.ceil(util.CRC(unixTime..curTime..tostring(math.random(1, 99998))) / 100002));
end;

function RP.item:Get(id)
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

function RP.item:GetWeapon(weapon)
	if (IsValid(weapon)) then
		local itemID = weapon:GetNWString("ItemID");
		if (itemID) then
			return self:Get(itemID);
		end;
	end;
	return false;
end;


if (SERVER) then

	function RP.item:InsertID(itemID, base, data)
		itemID = tostring(itemID);
		self.items[itemID] = self:Get(base);
		self.items[itemID].saveData = data;
		self.items[itemID].base = base;
		
		table.Merge(self.items[itemID], data);
		
		self.items[itemID].itemID = itemID;
	end;

	function RP.item:CreateID(base, data)
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

	function RP.item:DataID(itemID, data)
		if (self.items[itemID]) then
			table.Merge(self.items[itemID], data);
			table.Merge(self.items[itemID].saveData, data);
			return itemID;
		end;

		return false;
	end;

	function RP.item:RemoveID(itemID)
		self.items[itemID] = nil;
	end;
	
	function RP.item:CreateEntity(player, itemID, position)
		local itemStruct = ents.Create("rpItem");
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
	
	function RP.item:SendItemData(player, itemID)
		if (self:Get(itemID)) then
			local itemTable = self:Get(itemID);
			RP:DataStream(player, "ItemData", {itemID = itemID, base = itemTable.base, data = itemTable.saveData});
		end;
	end;
	
	RP:DataHook("RequestItem", function(player, data)
		if (data.itemID) then
			RP.item:SendItemData(player, data.itemID);
		end;
	end);		
	
else
	
	function RP.item:InsertData(itemID, base, data)
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
	function RP.item:DataID(itemID, data)
		if (self.items[itemID]) then
			table.Merge(self.items[itemID], data);
			return itemID;
		end;
		return false;
	end;	
	
	function RP.item:RequestData(itemID)
		RP:DataStream("RequestItem", {itemID = itemID});
	end;
	
	RP:DataHook("ItemData", function(data)
		if (data.itemID) then
			RP.item:InsertData(data.itemID, data.base, data.data);
		end;
	end);
end;

//Default item base goes here :(
local ITEM = {};
ITEM.uniqueID = "item_base";
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
	RP.inventory:TakeItem(player, self.itemID);
end;

RP.item:New(ITEM);