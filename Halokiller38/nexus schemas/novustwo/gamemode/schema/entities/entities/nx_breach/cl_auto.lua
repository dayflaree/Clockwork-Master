--[[
Name: "cl_auto.lua".
Product: "Novus Two".
--]]

NEXUS:IncludePrefixed("sh_auto.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = nexus.schema.GetColor("target_id");
	local colorWhite = nexus.schema.GetColor("white");
	
	y = NEXUS:DrawInfo("Breach", x, y, colorTargetID, alpha);
	y = NEXUS:DrawInfo("It can be directly charged.", x, y, colorWhite, alpha);
end;

-- Called when the entity should draw.
function ENT:Draw() self:DrawModel(); end;