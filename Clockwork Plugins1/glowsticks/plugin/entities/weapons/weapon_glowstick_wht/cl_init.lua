include('shared.lua')

SWEP.PrintName = "Glow Stick White"; 
SWEP.Slot = 1; 
SWEP.SlotPos = 1; 
SWEP.DrawAmmo = false;
SWEP.DrawCrosshair = false;

function SWEP:Think()
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos()
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.Brightness = 0
		dlight.Size = 256
		dlight.Decay = 0
		dlight.DieTime = CurTime() + 1
	end   
end