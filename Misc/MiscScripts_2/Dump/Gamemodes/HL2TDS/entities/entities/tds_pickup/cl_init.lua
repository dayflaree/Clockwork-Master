include('shared.lua')

ENT.Pos = Vector(0, 0, 0)

function ENT:Initialize()
	self.Pos = self:GetPos() + Vector(0, 0, 50)
end

function ENT:Draw()
	self:SetPos(self.Pos + (Vector(0, 0, 1) * math.sin(CurTime() * 2) * 8))
	self:SetAngles(Angle(-30, CurTime() * 60, 0))
	self:DrawModel()
end
