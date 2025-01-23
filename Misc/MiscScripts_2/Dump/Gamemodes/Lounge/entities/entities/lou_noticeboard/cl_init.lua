include('shared.lua')

function ENT:Initialize()
	self.HTML = vgui.Create("HTML")
	self.HTML:SetSize(1024, 1024)
	self.HTML:SetPos(0, 0)
	self.HTML:OpenURL("http://ubs-clan.co.uk")
	self.HTML:SetPaintedManually(true)
	self:SetRenderBounds(Vector(-3000, -3000, -3000), Vector(3000, 3000, 3000))
	self.HTML:StartAnimate(10000)
end

function ENT:Think()
	//self.HTML:OpenURL("http://ubs-clan.co.uk")
	//self:NextThink(CurTime() + 10)
	//return true
end

function ENT:Draw()
	self.Entity:DrawModel()
	local pos = self:GetPos() + (self.Entity:GetForward() * 50) + (self.Entity:GetUp() * 35) + (self.Entity:GetRight() * -10)
	local ang = self:GetAngles()
	//ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), 180)
	ang:RotateAroundAxis(ang:Forward(), 90)
	
	self.HTML:SetPaintedManually(false)
	
	cam.Start3D2D(pos, ang, 0.1) // change the scale
		self.HTML:PaintManual()
	cam.End3D2D()
	
	self.HTML:SetPaintedManually(true)
end
