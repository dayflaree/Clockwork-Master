--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

-- Called when the gamemode should save data
function PLUGIN:GlobalSaveData()
	for k, v in pairs(_player.GetAll()) do
		self:SavePlayerData(v);
	end;
end;

-- A function that's called when a player spawns
function PLUGIN:PlayerInitialSpawn(player)
	RP.chat:Add(_player.GetAll(), {Color(255, 245, 221), player:Name().." has joined the game!"}, "gui/silkicons/user");
	timer.Simple(1, self.LoadPlayerData, self, player);
end;

function PLUGIN:PlayerDisconnect(player)
	RP.chat:Add(_player.GetAll(), {Color(255, 245, 221), player:Name().." has disconnected."}, "gui/silkicons/user");
end;
	
-- A function that loads playerdata
function PLUGIN:LoadPlayerData(player)
	tmysql.query("SELECT * FROM players WHERE _SteamID = '"..RP.Data:Safe(player:SteamID()).."'", function(result, status, error)
		if (#result <= 0) then
			tmysql.query("INSERT INTO players VALUES (NULL, '"..RP.Data:Safe(player:SteamID()).."', '"..RP.Data:Safe(player:Name()).."', 0, '{}', '{}', '"..RP.Data:Safe(player:IPAddress()).."')");
			player.rpData = {};
			player.rpCash = 0;
			player.inventory = {};
		else
			tmysql.query("UPDATE players SET _Name = '"..RP.Data:Safe(player:Name()).."', _IP = '"..RP.Data:Safe(player:IPAddress()).."' WHERE _SteamID = '"..RP.Data:Safe(player:SteamID()).."'");
			local tableData = result[1];
			player.rpData = Json.Decode(tableData['_Data'] or {});
			player.rpCash = tonumber(tableData['_Cash']) or 0;
			player.inventory = Json.Decode(tableData['_Inventory'] or {});
			player:FilterInventory();
		end;
		self:NetworkPlayerData(player);
		self:NetworkPlayerCash(player);
		RP.Plugin:Call("PlayerDataLoaded", player);
	end);
end;

-- A function that saves playerdata
function PLUGIN:SavePlayerData(player)
	tmysql.query("UPDATE players SET _Inventory = '"..RP.Data:Safe(Json.Encode(player.inventory)).."', _Name = '"..RP.Data:Safe(player:Name()).."', _IP = '"..RP.Data:Safe(player:IPAddress()).."', _Cash = "..RP.Data:Safe(player:GetCash())..", _Data = '"..RP.Data:Safe(Json.Encode(player:GetDataTable())).."' WHERE _SteamID = '"..RP.Data:Safe(player:SteamID()).."'");
	--Reminder: Take out these later.
	self:NetworkPlayerData(player);
	self:NetworkPlayerCash(player);
end;

-- A function that streams playerData over to the client
function PLUGIN:NetworkPlayerData(player)
	RP:DataStream(player, "rpNetworkData", player:GetDataTable() or {});
end;

-- A function that streams playerCash over to the client
function PLUGIN:NetworkPlayerCash(player)
	RP:DataStream(player, "rpNetworkCash", {player:GetCash()});
end;

--[[
	PlayerMeta functions related to data go here
--]]

local playerMeta = FindMetaTable("Player");


function playerMeta:FilterInventory()
	local toRemove = {};
	for k, v in pairs(self.inventory) do
		if (!RP.Item.database[k]) then
			table.insert(toRemove, k);
		else	
			local count = 0;
			for itemID, itemData in pairs(v) do
				count = count + 1;
				RP.Item:InsertID(itemID, k, itemData);
			end;
			if (count == 0) then
				table.insert(toRemove, k);
			end;
		end;
	end;
	
	for k, v in pairs(toRemove) do
		self.inventory[v] = nil;
	end;
	
	self:SaveData();
end;

-- Saves
function playerMeta:SaveData()
	PLUGIN:SavePlayerData(self);
end;

-- Gets the player's cash amount
function playerMeta:GetCash()
	return self.rpCash;
end;

-- Sets the player's cash amount
function playerMeta:SetCash(amount)
	self.rpCash = amount;
	PLUGIN:NetworkPlayerCash(self);
end;

-- A function that adds cash to a player's cash amount
function playerMeta:GiveCash(amount)
	self:SetCash(self.rpCash + amount);
	RP:DataStream(self, "giveCash", {amount});
end;

-- A function that removes cash from a player's cash amount. Minimum is 0
function playerMeta:TakeCash(amount)
	self:SetCash(math.max(self.rpCash - amount, 0));
	RP:DataStream(self, "giveCash", {-amount});
end;

-- A function that can check if a player has the correct amount of money
function playerMeta:CanAfford(amount)
	if (self:GetCash() >= amount) then
		return true;
	end;
	
	return false;
end;

-- Returns the entire data table as a copy.
function playerMeta:GetDataTable()
	return table.Copy(self.rpData);
end;

-- Retrieves data about the player
function playerMeta:GetData(key)
	return self.rpData[key];
end;

-- Sets data for the Player's data table
function playerMeta:SetData(key, value)
	self.rpData[key] = value;
	PLUGIN:NetworkPlayerData(self);
end;

-- Plays a sound on the client.
function playerMeta:PlaySound(path)
	RP:DataStream(self, "rpPlaySound", {path});
end;
