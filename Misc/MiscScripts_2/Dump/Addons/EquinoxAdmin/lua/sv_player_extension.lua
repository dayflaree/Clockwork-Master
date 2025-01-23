local Player = FindMetaTable("Player")

Player.Properties = {}

function Player:SetProperty(key, value, shared)
	if shared and type(value) != "table" then
		self:SetNWString("EA_"..key, tostring(value))
	end
	self.Properties[key] = value
end

function Player:GetProperty(key)
	if not self.Properties["loaded"] then
		self:ReloadProperties()
	end
	return self.Properties[key] or nil
end

function Player:ReloadProperties()
	self.Properties = glon.decode(file.Read("ea/" .. self:UniqueID() .. ".txt"))
	self.Properties["loaded"] = true
end

function Player:SaveProperties()
	file.Write("ea/" .. self:UniqueID() .. ".txt", glon.encode(self.Properties))
end

timer.Create("EA_Properties_Timer", 60, 0, function() for k, ply in pairs(player.GetAll()) do ply:SaveProperties() end end)