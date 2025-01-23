local displays = {}
local screens = {}

concommand.Add("display_add", function(ply, cmd, args)
	local pos = ply:GetEyeTrace().HitPos + (ply:GetEyeTrace().HitNormal * 2)
	local ang = ply:GetEyeTrace().HitNormal:Angle()
	local text = table.concat(args, " ")
	
	--ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	
	--ang.r = 0
	
	table.insert(displays, { Position = pos, Angle = ang, Text = text })
end)

concommand.Add("screens_add", function(ply, cmd, args)
	local pos = ply:GetEyeTrace().HitPos
	local ang = ply:GetEyeTrace().HitNormal:Angle()
	local id = args[1]
	local width = args[2]
	local height = args[3]
	
	--ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	
	--ang.r = 0
	
	screens[id] = { Position = pos, Angle = ang, Width = width, Height = height }
end)

hook.Add("PostDrawOpaqueRenderables", "fesf", function()
	for id, display in pairs(displays) do
		cam.Start3D2D(display.Position, display.Angle, 0.5)
			draw.DrawText(display.Text, "HUDNumber5", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
	
	local r, g, b, a = 0, 0, 0, 255
	
	for id, screen in pairs(screens) do
		cam.Start3D2D(screen.Position, screen.Angle, 1)
			surface.SetDrawColor(r, g, b, a)
			surface.DrawRect(0, 0, screen.Width, screen.Height)
		cam.End3D2D()
	end
end)