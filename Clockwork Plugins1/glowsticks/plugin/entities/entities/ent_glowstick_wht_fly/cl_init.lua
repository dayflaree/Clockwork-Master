include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self.Entity:DrawModel()
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