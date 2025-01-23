function DrawName(ply)
	if !ply:Alive() then return end
 
	local offset = Vector(0, 0, 79)
	local ang = LocalPlayer():EyeAngles()
	local pos = ply:GetPos() + offset + ang:Up()
 
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)
	
	cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.25)
		-- LevelToString is an assmod function.
		draw.DrawText(LevelToString(ply:GetLevel()), "HUDNumber", 2, 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	cam.End3D2D()
 
end
hook.Add("PostPlayerDraw", "DrawName", DrawName)