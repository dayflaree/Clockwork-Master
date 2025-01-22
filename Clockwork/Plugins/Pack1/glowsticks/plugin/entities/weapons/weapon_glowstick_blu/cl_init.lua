include('shared.lua')

SWEP.PrintName = "Glow Stick Blue"; 
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
		dlight.g = 0
		dlight.b = 240
		dlight.Brightness = 0
		dlight.Size = 256
		dlight.Decay = 0
		dlight.DieTime = CurTime() + 1
	end   
end