--[[
Name: "cl_auto.lua".
Product: "Day One".
--]]

BLUEPRINT:IncludePrefixed("sh_auto.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = blueprint.design.GetColor("target_id");
	local colorWhite = blueprint.design.GetColor("white");
	
	y = BLUEPRINT:DrawInfo("Paper", x, y, colorTargetID, alpha);
	
	if ( self:GetSharedVar("sh_Note") ) then
		y = BLUEPRINT:DrawInfo("It has been written on.", x, y, colorWhite, alpha);
	else
		y = BLUEPRINT:DrawInfo("It is blank.", x, y, colorWhite, alpha);
	end;
end;

-- Called when the entity initializes.
function ENT:Initialize()
	self:SharedInitialize();
end;

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;