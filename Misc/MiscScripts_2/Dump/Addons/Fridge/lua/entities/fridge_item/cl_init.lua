include('shared.lua')
function ENT:Draw()
	self:DrawModel()
	surface.SetFont("FTitle")
	
	local pos = self:GetPos() + self:GetForward() * 10
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
	
	local str = self:GetNWString("fridge_title") or "TEXT"
	
	cam.Start3D2D(pos, ang, 0.1)
		draw.SimpleText(str, "FTitle", 0, 0, Color(15, 248, 5, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end