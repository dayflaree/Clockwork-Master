--[[
Name: "cl_auto.lua".
Product: "Day One".
--]]

include("sh_auto.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = blueprint.design.GetColor("target_id");
	local colorWhite = blueprint.design.GetColor("white");
	
	y = BLUEPRINT:DrawInfo("Belongings", x, y, colorTargetID, alpha);
	y = BLUEPRINT:DrawInfo("There might be something inside.", x, y, colorWhite, alpha);
end;

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;