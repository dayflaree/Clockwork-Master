--[[
Name: "cl_auto.lua".
Product: "Day One".
--]]

include("sh_auto.lua")

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;