local Player = FindMetaTable("Player")

Player.Properties = {}

function Player:GetProperty(key)
	return self:GetNWString("EA_"..key)
end