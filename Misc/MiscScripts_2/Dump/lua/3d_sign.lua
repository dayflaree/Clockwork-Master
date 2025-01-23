function DrawDisplay()
	cam.Start3D2D(Vector(0, 0, 200), Angle(0, 90, 90), 10)
		draw.DrawText("TEXT", "ScoreboardText", 1, 1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
hook.Add("PostDrawOpaqueRenderables", "DrawShit", DrawDisplay)