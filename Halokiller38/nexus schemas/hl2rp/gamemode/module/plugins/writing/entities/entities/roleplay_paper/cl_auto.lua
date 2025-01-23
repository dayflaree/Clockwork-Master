--[[
Name: "cl_auto.lua".
Product: "Kyron".
--]]

RESISTANCE:IncludePrefixed("sh_auto.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = resistance.module.GetColor("target_id");
	local colorWhite = resistance.module.GetColor("white");
	
	y = RESISTANCE:DrawInfo("Paper", x, y, colorTargetID, alpha);
	
	if ( self:GetSharedVar("sh_Note") ) then
		y = RESISTANCE:DrawInfo("It has been written on.", x, y, colorWhite, alpha);
	else
		y = RESISTANCE:DrawInfo("It is blank.", x, y, colorWhite, alpha);
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