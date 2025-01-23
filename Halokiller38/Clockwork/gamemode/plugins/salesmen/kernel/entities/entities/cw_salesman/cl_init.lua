--[[
	Free Clockwork!
--]]

Clockwork:IncludePrefixed("shared.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	local physDesc = self:GetNWString("PhysDesc");
	local name = self:GetNWString("Name");
	
	y = Clockwork:DrawInfo(name, x, y, colorTargetID, alpha);
	
	if (physDesc != "") then
		y = Clockwork:DrawInfo(physDesc, x, y, colorWhite, alpha);
	end;
end;

-- Called when the entity initializes.
function ENT:Initialize()
	self.AutomaticFrameAdvance = true;
end;

-- Called every frame.
function ENT:Think()
	self:FrameAdvance(FrameTime());
	self:NextThink(CurTime());
end;