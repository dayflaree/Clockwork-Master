--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

RP:DataHook("rpNetworkData", function(data)
	RP.Client.rpData = data;
end);

RP:DataHook("rpNetworkCash", function(data)
	RP.Client.rpCash = data[1];
end);

RP:DataHook("giveCash", function(data)
	local amount = data[1];
	RP.Hud:AddCashFall(amount);
end);

RP:DataHook("rpPlaySound", function(data)
	local sound = data[1];
	surface.PlaySound(sound);
end);

--[[
	PlayerMeta functions related to data go here
--]]

local playerMeta = FindMetaTable("Player");

-- Gets the player's cash amount
function playerMeta:GetCash()
	return self.rpCash;
end;

-- Sets the player's cash amount
function playerMeta:SetCash(amount)
	self.rpCash = amount;
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

-- Plays a sound on the client.
function playerMeta:PlaySound(path)
	surface.PlaySound(path);
end;
