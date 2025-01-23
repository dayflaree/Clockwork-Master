--[[--
	-- Generic Incomplete Gamemode --
	
	File: sv_player_extension.lua
	Purpose: Extends the Player metatable serverside to provide attitional functions.
	Created: 18th August 2010 By: _Undefined
--]]--

local Player = FindMetaTable("Player")

-- Settings

function Player:GetSetting(key)
	local value = self:GetPData(key, false)
	return value
end

function Player:SaveSetting(key, value, sharedwithall)
	local ply = self
	
	if sharedwithall then
		ply = player.GetAll()
	end
	
	self:SetPData(key, value)
	datastream.StreamToClients(ply, "PlayerSetting", {ply = self, key = key, value = value})
	
	return value
end

-- Inventory Stuff (to be changed by Advert?)

function Player:GiveItem(id)
	-- Placeholder
	local items = self:GetSetting("inventory")
	table.insert(items, id)
end

function Player:TakeItem(id)
	local items = self:GetSetting("inventory")
	
	for k, itemid in pairs(items) do
		if itemid == id then
			table.remove(items, k)
		end
	end
	
	self:SaveSetting("inventory", items)
end

-- Missions Stuff

AccessorFunc(Player, "ActiveMission", "ActiveMission")

function Player:GetAvailableMissions()
	local rtn = {}
	
	for k, m in pairs(GM.Missions) do
		if m.IsAvailable(self) then -- Allows the mission to tell us if it is available.
			table.insert(rtn, m)
		end
	end
	
	if #rtn > 0 then
		-- Return the table here if there are any entries.
		-- This could be used on say a computer terminal in the game, to list available missions.
		return rtn
	end
	
	return false
end

function Player:StartMission(id)
	-- Placeholder
	local m = GAMEMODE:GetMission(id)
	self:SetActiveMission(m)
end

function Player:CancelMission(id)
	-- Placeholder
	self:SetActiveMission(false)
end

function Player:FinishMission(id)
	-- Placeholder
	if self:GetIsInMission() then
		
		self:SetIsInMission(false)
	end
end