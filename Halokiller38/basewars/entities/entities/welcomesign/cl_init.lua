include('shared.lua')

function ENT:Draw( bDontDrawModel )
	self:DrawModel()
	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	
	surface.SetFont("HUDNumber5")
	local TextWidth = surface.GetTextSize("Welcome to Infamous Gaming! We missed you!")

	Ang:RotateAroundAxis(Ang:Up(), 90)

	cam.Start3D2D(Pos + Ang:Up(), Ang, 1)
		draw.WordBox(1, 0, 0, "Welcome to Infamous Gaming! We missed you", "TabLarge", Color(230, 232, 250, 0), Color(255,255,255,255))
	cam.End3D2D()
end