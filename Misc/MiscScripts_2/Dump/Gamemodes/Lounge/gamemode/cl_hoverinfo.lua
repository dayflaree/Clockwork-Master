function DrawHoverInfo(ent)
	local SelfPos = LocalPlayer():GetShootPos()
	if ent:GetClass() == "prop_door_rotating" then
		TargetPos = ent:LocalToWorld(ent:OBBCenter())
		Pos = TargetPos:ToScreen()
		Pos.y = Pos.y - 32
	else
		local tp = ent:OBBMaxs()
		TargetPos = ent:LocalToWorld(Vector(0, 0, tp.z))
		Pos = TargetPos:ToScreen()
		Pos.y = Pos.y - 32
	end

	Alpha = 1000 - ent:GetPos():Distance(SelfPos)
	Alpha = math.Clamp(Alpha, 0, 255)
	if ent:GetNWString('HoverColoura') != "" then
		Colour2 = Color(ent:GetNWString('HoverColourr'), ent:GetNWString('HoverColourg'), ent:GetNWString('HoverColourb'), ent:GetNWString('HoverColoura'))
	else
		Colour2 = Color(255, 255, 255, Alpha)
	end
	
	ShouldDraw = true
	
	if Pos.visible then
		local Dist = SelfPos:Distance(TargetPos)
		local Tra = {}
		Tra.start = SelfPos
		Tra.endpos = TargetPos
		Tra.mask = MASK_SOLID_BRUSHONLY
		local Trace = util.TraceLine(Tra)
		
		if Trace.HitWorld then
			ShouldDraw = false
		end
	else
		ShouldDraw = false
	end
	
	if ent:IsPlayer() then ShouldDraw = true end

	if ShouldDraw then
		if ent:IsPlayer() then
			ply = ent
			Colour2 = team.GetColor(ply:Team())
			if ply:IsAdmin() then
				icon = "shield"
			else
				icon = "user"
			end
			if ply:GetNWBool('typing') == true then
				icon = "comment"
			end
			if ply:GetNWBool('afk') == true then
				icon = "user_go"
			end
		else
			icon = ent:GetNWString('HoverIcon')
			if not icon then icon = "information" end
		end
		info = ent:GetNWString('HoverInfo')
		surface.SetFont("TargetIDSmall")
		w, h = surface.GetTextSize(info)
		tl = Pos.x - ((w + 24) / 2)
		draw.RoundedBox(6, tl, Pos.y, w + 26, 20, Color(0, 0, 0, math.Clamp(Alpha, 0, 150)))
		draw.SimpleText(info, "TargetIDSmall", tl + 22, Pos.y + 10, Colour2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)					
		local tex = surface.GetTextureID("gui/silkicons/"..icon)
		surface.SetTexture(tex)
		surface.SetDrawColor(255, 255, 255, Alpha)
		surface.DrawTexturedRect(tl + 2, Pos.y + 2, 16, 16)
	end
end

function GM:PaintHoverInfo()
	for k, ent in pairs(ents.GetAll()) do
		if ent:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
			if ent:GetNWString('HoverInfo') != "" then
				DrawHoverInfo(ent)
			end
		end
	end
end
