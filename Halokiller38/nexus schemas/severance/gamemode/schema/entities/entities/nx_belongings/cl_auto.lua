--[[
Name: "cl_auto.lua".
Product: "Severance".
--]]

include("sh_auto.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = nexus.schema.GetColor("target_id");
	local colorWhite = nexus.schema.GetColor("white");
	
	y = NEXUS:DrawInfo("Belongings", x, y, colorTargetID, alpha);
	y = NEXUS:DrawInfo("There might be something inside.", x, y, colorWhite, alpha);
end;

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;