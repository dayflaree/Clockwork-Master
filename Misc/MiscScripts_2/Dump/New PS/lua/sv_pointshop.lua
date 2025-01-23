function POINTSHOP.PlayerInitialSpawn(ply)
	-- Set defaults
	ply.PS_Points = 0
	ply.PS_Items = {}
	
	POINTSHOP.Hats[ply] = {}
	
	-- Send player points, items and hats
	ply:PS_SetPoints(tonumber(ply:GetPData("PointShop_Points", 0)))
	ply:PS_SetItems(glon.decode(ply:GetPData("PointShop_Items")))
	ply:PS_SendHats()

	-- Re-give any items in inventory
	for _, item_id in pairs(ply:PS_GetItems()) do
		local item = POINTSHOP.FindItemByID(item_id)
		if item and item.Functions and item.Functions.OnGive then
			item.Functions.OnGive(ply, item)
		end
	end
end

function POINTSHOP.PostInitEntity()
	-- Create NPC sellers
end

hook.Add("PlayerInitialSpawn", "PS_PlayerInitialSpawn", POINTSHOP.PlayerInitialSpawn)
hook.Add("PostInitEntity", "PS_PostInitEntity", POINTSHOP.PostInitEntity)

-- Item commands
function POINTSHOP.BuyItem(ply, cmd, args)
	
end

function POINTSHOP.SellItem(ply, cmd, args)
	
end

function POINTSHOP.RespawnItem(ply, cmd, args)
	
end

-- Admin commands
function POINTSHOP.SetPoints(ply, cmd, args)
	if not ply:IsAdmin() then return end
	
	local to_set = POINTSHOP.FindPlayerByName(args[1])
	local points = tonumber(args[2]) or false
	
	if not to_set or not points then return end
	
	to_set:PS_SetPoints(points)
	to_set:PS_Notify("Points set to " .. points .. " by " .. ply:Nick())
end

function POINTSHOP.GivePoints(ply, cmd, args)
	if not ply:IsAdmin() then return end
	
	local to_give = POINTSHOP.FindPlayerByName(args[1])
	local points = tonumber(args[2]) or false
	
	if not to_give or not points then return end
	
	to_give:PS_GivePoints(points)
	to_give:PS_Notify("Given " .. points .. " points by " .. ply:Nick())
end

function POINTSHOP.TakePoints(ply, cmd, args)
	if not ply:IsAdmin() then return end
	
	local to_take = POINTSHOP.FindPlayerByName(args[1])
	local points = tonumber(args[2]) or false
	
	if not to_take or not points then return end
	
	to_take:PS_TakePoints(points)
	to_take:PS_Notify("Taken " .. points .. " points by " .. ply:Nick())
end

concommand.Add("ps_buyitem", POINTSHOP.BuyItem)
concommand.Add("ps_sellitem", POINTSHOP.SellItem)
concommand.Add("ps_respawnitem", POINTSHOP.RespawnItem)

concommand.Add("ps_setpoints", POINTSHOP.SetPoints)
concommand.Add("ps_givepoints", POINTSHOP.GivePoints)
concommand.Add("ps_takepoints", POINTSHOP.TakePoints)

local Player = FindMetaTable("Player")

-- Notify function
function Player:PS_Notify(text)
	SendUserMessage("PS_Notify", self, text)
end

-- Points functions
function Player:PS_GetPoints()
	return self.PS_Points
end

function Player:PS_SetPoints(points)
	self.PS_Points = points
	self:PS_UpdatePoints()
end

function Player:PS_GivePoints(points)
	self:PS_SetPoints(self:PS_GetPoints() + points)
	self:PS_UpdatePoints()
end

function Player:PS_TakePoints(points)
	self:PS_SetPoints(self:PS_GetPoints() - points < 1 and 0 or self:PS_GetPoints() - points)
	self:PS_UpdatePoints()
end

function Player:PS_UpdatePoints()
	self:SetPData("PointShop_Points", self:PS_GetPoints())
	SendUserMessage("PS_Points", self, self:PS_GetPoints())
end

-- Items functions
function Player:PS_GetItems()
	return self.PS_Items
end

function Player:PS_SetItems(items)
	self.PS_Items = POINTSHOP.ValidateItems(items)
	self:PS_UpdateItems()
end

function Player:PS_GiveItem(item_id)
	if not self:PS_HasItem(item_id) then table.insert(self:PS_GetItems(), item_id) end
	
	self:PS_UpdateItems()
	
	local item = POINTSHOP.FindItemByID(item_id)
	
	if item and item.Functions and item.Functions.OnGive then
		item.Functions.OnGive(self, item)
	end 
end

function Player:PS_TakeItem(item_id)
	if self:PS_HasItem(item_id) then
		for k, id in pairs(self:PS_GetItems()) do
			if id == item_id then
				table.remove(self:PS_GetItems(), k)
			end
		end
	end
	
	self:PS_UpdateItems()
	
	local item = POINTSHOP.FindItemByID(item_id)
	
	if item and item.Functions and item.Functions.OnTake then
		item.Functions.OnTake(self, item)
	end 
end

function Player:PS_UpdateItems()
	self:SetPData("PointShop_Items", glon.encode(self:PS_GetItems()))
	datastream.StreamToClients(self, "PS_Items", self:PS_GetItems())
end

function Player:PS_HasItem(item_id)
	return table.HasValue(self:PS_GetItems(), item_id)
end

-- Menu functions
function Player:PS_ShowShop(bool)
	SendUserMessage("PS_ShowShop", self, bool or true)
end

function Player:PS_ToggleShop()
	self:PS_ShowShop(false)
	self:PS_ShowShop(true)
end

-- Hats functions
function Player:PS_AddHat(item_id)
	POINTSHOP.Hats[self][item_id] = item_id
	SendUserMessage("PS_AddHat", player.GetAll(), self, item_id)
end

function Player:PS_RemoveHat(item_id)
	POINTSHOP.Hats[self][item_id] = nil
	SendUserMessage("PS_RemoveHat", player.GetAll(), self, item_id)
end

function Player:PS_SendHats()
	for ply, hats in pairs(POINTSHOP.Hats) do
		for _, item_id in pairs(hats) do
			SendUserMessage("PS_AddHat", self, ply, item_id)
		end
	end
end