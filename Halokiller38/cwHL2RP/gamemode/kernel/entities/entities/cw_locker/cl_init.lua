--[[
	Free Clockwork!
--]]

Clockwork:IncludePrefixed("shared.lua")

-- Called when the entity should draw.
function ENT:Draw() self:DrawModel(); end;