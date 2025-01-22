include('shared.lua')

SWEP.PrintName = "Glow Stick"; 
SWEP.Slot = 1; 
SWEP.SlotPos = 1; 
SWEP.DrawAmmo = false;
SWEP.DrawCrosshair = false;

function SWEP:Think()
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos()
		dlight.r = 0
		dlight.g = 255
		dlight.b = 0
		dlight.Brightness = 1
		dlight.Size = 256
		dlight.Decay = 0
		dlight.DieTime = CurTime() + 1
	end
	return true
end