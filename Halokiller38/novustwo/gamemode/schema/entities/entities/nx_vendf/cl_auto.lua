--[[
Name: "cl_auto.lua".
Product: "HL2 RP".
--]]

NEXUS:IncludePrefixed("sh_auto.lua")

local ply = g_LocalPlayer
local glowMaterial = Material("sprites/glow04_noz");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SharedInitialize();
end;

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha, player)
	local colorTargetID = nexus.schema.GetColor("target_id");
	local colorWhite = nexus.schema.GetColor("white");
	
	y = NEXUS:DrawInfo("A Vending Machine", x, y, colorTargetID, alpha);
	
	if (g_LocalPlayer:GetPos():Distance( self:GetPos() ) <= 80) then
		y = NEXUS:DrawInfo("Press E to buy a Nuka Cola drink for 22 Caps.", x, y, colorWhite, alpha);
	else
		y = NEXUS:DrawInfo("This machine.. Seems useable again, probably sells drinks.", x, y, colorWhite, alpha);
	end;
end;

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;