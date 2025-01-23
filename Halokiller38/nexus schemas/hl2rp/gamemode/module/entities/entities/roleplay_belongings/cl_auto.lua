--[[
Name: "cl_auto.lua".
Product: "resistance".
--]]

include("sh_auto.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = resistance.module.GetColor("target_id");
	local colorWhite = resistance.module.GetColor("white");
	
	y = RESISTANCE:DrawInfo("Belongings", x, y, colorTargetID, alpha);
	y = RESISTANCE:DrawInfo("There might be something inside.", x, y, colorWhite, alpha);
end;

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;