--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

function ENT:Draw()
	self.Entity:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	
	surface.SetFont("ChatFont")
	local TextWidth = surface.GetTextSize("$"..tostring(self:GetNWInt("amount")))	
	
	cam.Start3D2D(Pos + Ang:Up() * 0.9, Ang, 0.2)
		draw.WordBox(3, -TextWidth*0.5, -10, "$"..tostring(self:GetNWInt("amount")), "ChatFont", Color(0, 0, 255, 100), Color(255, 255, 255, 255))
	cam.End3D2D()
	
	Ang:RotateAroundAxis(Ang:Right(), 180)
	
	cam.Start3D2D(Pos, Ang, 0.2)
		draw.WordBox(3, -TextWidth*0.5, -10, "$"..tostring(self:GetNWInt("amount")), "ChatFont", Color(0, 0, 255, 100), Color(255, 255, 255, 255))
	cam.End3D2D()
end