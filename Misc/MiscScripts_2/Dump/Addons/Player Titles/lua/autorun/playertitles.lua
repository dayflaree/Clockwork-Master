local Player = FindMetaTable("Player")

function Player:IsTyping()
	return self:GetNWBool("Typing") or false
end

if CLIENT then
	hook.Add("StartChat", "PT_StartChat", function() RunConsoleCommand("PT_StartChat") end)
	hook.Add("FinishChat", "PT_FinishChat", function() RunConsoleCommand("PT_FinishChat") end)
	
	local function ToWidth(s, f)
		surface.SetFont("ScoreboardText")
		local w = surface.GetTextSize(s, f)
		return w
	end
	
	local usericon, adminicon, typingicon = surface.GetTextureID("gui/silkicons/user"), surface.GetTextureID("gui/silkicons/shield"), surface.GetTextureID("gui/silkicons/comment")

	hook.Add("HUDPaint", "Titles", function()
		for k, ply in pairs(player.GetAll()) do
			if not ply == LocalPlayer() then
				local dist = ply:GetPos():Distance(LocalPlayer():GetPos())
				if dist < 2000 then
					local pos = (ply:GetPos() + Vector(0, 0, 100)):ToScreen()
					local x = pos.x
					local y = pos.y
					local w = ToWidth(ply:Nick()) + 32
					draw.RoundedBox(6, x - (w / 2), y, w, 23, Color(0, 0, 0, math.Clamp(2000 - dist, 0, 100)))
					if ply:IsAdmin() then icon = adminicon else icon = usericon end
					if ply:IsTyping() then icon = typingicon end
					surface.SetTexture(icon)
					surface.SetDrawColor(255, 255, 255, math.Clamp(2000 - dist, 0, 255))
					surface.DrawTexturedRect(x - (w / 2) + 6, y + 3, 16, 16)
					local col = team.GetColor(ply:Team())
					col.a = math.Clamp(2000 - dist, 0, 255)
					draw.SimpleText(ply:Nick(), "ScoreboardText", x + 10, y + 11, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					if ply:GetNWString("PT_Title") != "" then
						y = y + 30
						w = ToWidth(ply:GetNWString("PT_Title")) + 12
					
						draw.RoundedBox(6, x - (w / 2), y, w, 23, Color(0, 0, 0, math.Clamp(2000 - dist, 0, 100)))
						local col = team.GetColor(ply:Team())
						col.a = math.Clamp(2000 - dist, 0, 255)
						draw.SimpleText(ply:GetNWString("PT_Title"), "ScoreboardText", x + 1, y + 11, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end
			end
		end
	end)
end

if SERVER then
	AddCSLuaFile("autorun/playertitles.lua")
	
	concommand.Add("PT_StartChat", function(ply, cmd, args) ply:SetNWBool("Typing", true) end)
	concommand.Add("PT_FinishChat", function(ply, cmd, args) ply:SetNWBool("Typing", false) end)
	
	concommand.Add("settitle", function(ply, cmd, args)
		local name, title, to_set = nil, nil, nil
		
		if #args > 1 then
			name = args[1]
			title = table.concat(args, " ", 2)
		else
			title = table.concat(args, " ")
		end
		
		if name then
			for k, p in pairs(player.GetAll()) do
				if string.find(p:Nick(), name) then
					to_set = p
				end
			end
		else
			to_set = ply
		end
		
		to_set:SetPData("PT_Title", title)
		to_set:SetNWString("PT_Title", title)
	end)
	
	hook.Add("PlayerInitialSpawn", "SetTitle", function(ply)
		local title = ply:GetPData("PT_Title")
		
		if title then
			ply:SetNWString("PT_Title", title)
			ply:ChatPrint("[PT] Your title is set to: '" .. title .. "'")
		end
	end)
end