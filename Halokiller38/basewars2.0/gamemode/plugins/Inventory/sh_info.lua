--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

PLUGIN.name = "Inventory";

RP.Inventory = {};
RP:IncludeFile("cl_derma.lua");
local playerMeta = FindMetaTable("Player");

if (SERVER) then
	
	
	function playerMeta:GiveItem(itemID)
		return RP.Inventory:GiveItem(self, itemID);
	end;
	
	function playerMeta:TakeItem(itemID)
		return RP.Invenotry:TakeItem(itemID);
	end;
	
	function playerMeta:HasItem(itemID)
		return RP.Inventory:HasItem(itemID);
	end;
	
	function playerMeta:DropItem(uniqueID, itemID)
		return RP.Inventory:DropItem(self, uniqueID, itemID);
	end;
	
	function playerMeta:NetworkInventory()
		return RP.Inventory:SendInventory(self);
	end;
	
	//Base functions
	
	function RP.Inventory:Get(player)
		return player.inventory;
	end;
	
	function RP.Inventory:GiveItem(player, itemID)
		local itemTable = RP.Item:Get(itemID);
			
		if (self:Get(player)[itemTable.uniqueID] == nil) then
			self:Get(player)[itemTable.uniqueID] = {};
		end;
		
		self:Get(player)[itemTable.uniqueID][tostring(itemID)] = itemTable.saveData;

		player:SaveData();
		self:SendInventory(player);
	end;

	function RP.Inventory:TakeItem(player, itemID)
		
		local itemTable = RP.Item:Get(itemID);
	
		player.inventory[itemTable.uniqueID][itemID] = nil;
		player:SaveData();
		self:SendInventory(player);
	end;
	
	function RP.Inventory:HasItem(player, uniqueID, itemID)
		if (self:Get(player)[uniqueID] and !itemID) then
			return true;
		end;
		
		if (itemID and self:Get(player)[uniqueID][itemID]) then
			return true;
		end;
		
		return false;
	end;
	
	function RP.Inventory:DropItem(player, uniqueID, itemID)
		local trace = player:EyeTrace(100);
		local pos = trace.HitPos;
		
		local entity = RP.Item:CreateEntity(player, itemID, pos);
		
		if (!IsValid(entity)) then
			player:Notify("An unknown error has occured");
			return false;
		end;
		
		RP:MakeFlushToGround(entity, pos, trace.HitNormal);
		
		player:UnloadItem(itemID);
		self:TakeItem(player, itemID);
		self:SendInventory(player);
		return true;
	end;
	
	function RP.Inventory:PickupItem(player, entity, itemID)
		if (entity:GetPos():Distance(player:GetPos()) > 150) then
			player:Notify("You can not pickup an item that far away!");
			return false;
		end;
		
		if (IsValid(entity)) then
			entity:Remove();
		end;
		
		self:GiveItem(player, itemID);
		self:SendInventory(player);
		return true;
	end;
	
	RP:DataHook("RequestInventory", function(player, data)
		RP.Inventory:SendInventory(player);
	end);
	
	function RP.Inventory:SendInventory(player)
		player:FilterInventory();
		RP:DataStream(player, "PlayerInventory", player.inventory);
	end;

		
else
	
	function RP.Inventory:Get()
		return RP.Client.inventory;
	end;
	
	function RP.Inventory:GetPanel()
		return self.Panel;
	end;
	
	function RP.Inventory:Request()
		RP:DataStream("RequestInventory", {});
	end;
	
	RP:DataHook("PlayerInventory", function(data)
		RP.Client.inventory = data;
		for k, v in pairs(data) do
			for itemID, itemData in pairs(v) do
				RP.Item:InsertData(itemID, k, itemData);
			end;
		end;
		RP.Inventory:GetPanel():Rebuild();
	end);
	
	
	

end;


function playerMeta:GetWeaponTable(isSecondary)
	local weaponID = self.primaryWeapon;
	if (isSecondary) then
		weaponID = self.secondaryWeapon;
	end;
	
	local weaponTable = RP.Item:Get(weaponID);
	
	return weaponTable;
end;

local COMMAND = {};
COMMAND.description = "Runs an inventory command";
COMMAND.arguments = {{"String", "Action"}, {"String", "ItemID"}, {"String", "uniqueID"}};
function COMMAND:OnRun(player, arguments)
	if (!RP.Item:Get(arguments[2])) then
		player:Notify("Invalid uniqueID or itemID!");
		return false;
	end;
		
	local action = arguments[1];
	local itemID = arguments[2];
	local uniqueID = arguments[3];
	
	local itemTable = RP.Item:Get(itemID);
	if (!RP.Inventory:HasItem(player, uniqueID, itemID)) then
		player:Notify("You do not own a "..itemTable.name.." ("..itemID..")!");
		return false;
	end;
	
	if (action == "use") then
		itemTable:OnUse(player, itemID);
	
	elseif (action == "unequip") then
		player:UnloadItem(itemID);
		
	elseif (action == "drop") then
		if (itemTable:OnDrop(player)) then
			RP.Inventory:DropItem(player, uniqueID, itemID);
		else
			player:Notify("You cannot drop that item");
		end;
		
	else
		player:Notify("Invalid Inventory Action!");
	end;
end;

RP.Command:New("inventory", COMMAND);