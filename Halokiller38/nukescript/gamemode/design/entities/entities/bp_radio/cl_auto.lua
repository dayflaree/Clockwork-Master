--[[
Name: "cl_auto.lua".
Product: "Day One".
--]]

BLUEPRINT:IncludePrefixed("sh_auto.lua")

local glowMaterial = Material("sprites/glow04_noz");

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = blueprint.design.GetColor("target_id");
	local colorWhite = blueprint.design.GetColor("white");
	local frequency = self:GetSharedVar("sh_Frequency");
	
	y = BLUEPRINT:DrawInfo("Radio", x, y, colorTargetID, alpha);
	
	if (frequency == "") then
		y = BLUEPRINT:DrawInfo("This radio has no frequency.", x, y, colorWhite, alpha);
	else
		y = BLUEPRINT:DrawInfo(frequency, x, y, colorWhite, alpha);
	end;
end;

-- Called when the entity initializes.
function ENT:Initialize()
	self:SharedInitialize();
end;

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
	
	local r, g, b, a = self:GetColor();
	local glowColor = Color(0, 255, 0, a);
	local position = self:GetPos();
	local forward = self:GetForward() * 9;
	local right = self:GetRight() * 5;
	local up = self:GetUp() * 8;
	
	if ( self:IsOff() ) then
		glowColor = Color(255, 0, 0, a);
	end;
	
	cam.Start3D( EyePos(), EyeAngles() );
		render.SetMaterial(glowMaterial);
		render.DrawSprite(position + forward + right + up, 16, 16, glowColor);
	cam.End3D();
end;