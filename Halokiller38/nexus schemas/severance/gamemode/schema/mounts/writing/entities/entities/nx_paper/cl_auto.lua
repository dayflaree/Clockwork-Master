--[[
Name: "cl_auto.lua".
Product: "Severance".
--]]

NEXUS:IncludePrefixed("sh_auto.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = nexus.schema.GetColor("target_id");
	local colorWhite = nexus.schema.GetColor("white");
	
	y = NEXUS:DrawInfo("Paper", x, y, colorTargetID, alpha);
	
	if ( self:GetSharedVar("sh_Note") ) then
		y = NEXUS:DrawInfo("It has been written on.", x, y, colorWhite, alpha);
	else
		y = NEXUS:DrawInfo("It is blank.", x, y, colorWhite, alpha);
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