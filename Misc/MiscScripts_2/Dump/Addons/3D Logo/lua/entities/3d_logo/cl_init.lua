include('shared.lua')

function ENT:Initialize()
	surface.CreateFont("coolvetica", 70, 400, true, false, "3DLogo")
	self:SetRenderBounds(Vector(-50000, -50000, -50000), Vector(50000, 50000, 50000))
	self:SetRenderBoundsWS(Vector(-50000, -50000, -50000), Vector(50000, 50000, 50000))
end

ENT.Text = "Build Server!"
local tex = surface.GetTextureID("es/logo")

function ENT:Draw()
	local pos = self:GetPos() + Vector(0, 0, 1) * math.sin(CurTime() * 2) * 12
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
	
	cam.Start3D2D(pos, ang, 1)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(tex)
		surface.DrawTexturedRect(-512, -128, 1024, 256)
		if self.Text then
			draw.SimpleText(self.Text, "3DLogo", 0, 170, Color(5, 147, 237, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
	
	ang:RotateAroundAxis(ang:Right(), 180)
	
	cam.Start3D2D(pos, ang, 1)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(tex)
		surface.DrawTexturedRect(-512, -128, 1024, 256)
		if self.Text then
			draw.SimpleText(self.Text, "3DLogo", 0, 170, Color(5, 147, 237, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end

usermessage.Hook("3d_logo_text", function(um)
	local ent = ents.FindByClass("3d_logo")[1]
	ent.Text = um:ReadString()
end)