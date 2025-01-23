RP.Inventory = {};
print("FDSA!");
if (SERVER) then
	
	function RP.Inventory:Get(player)
		return player.inventory;
	end;
	
	function RP.Inventory:GiveItem(player, itemID)
		local itemTable = RP.item:Get(itemID);
			
		if (self:Get(player)[itemTable.uniqueID] == nil) then
			self:Get(player)[itemTable.uniqueID] = {};
		end;
		
		self:Get(player)[itemTable.uniqueID][tostring(itemID)] = itemTable.saveData;

		player:SaveData();
		self:SendInventory(player);
	end;

	function RP.Inventory:TakeItem(player, itemID)
		
		local itemTable = RP.item:Get(itemID);
	
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
		local trace = player:GetEyeTraceNoCursor();
		local pos = trace.HitPos;
		if (pos:Distance(player:GetPos()) > 150) then
			player:Notify("You can not place an item that far away!");
			return false;
		end;
		
		local entity = RP.item:CreateEntity(player, itemID, pos);
		
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
		return RP.menu.menus["Inventory"];
	end;
	
	function RP.Inventory:Request()
		RP:DataStream("RequestInventory", {});
	end;
	
	RP:DataHook("PlayerInventory", function(data)
		RP.Client.inventory = data;
		for k, v in pairs(data) do
			for itemID, itemData in pairs(v) do
				RP.item:InsertData(itemID, k, itemData);
			end;
		end;
		RP.Inventory:GetPanel():Rebuild();
	end);

end;