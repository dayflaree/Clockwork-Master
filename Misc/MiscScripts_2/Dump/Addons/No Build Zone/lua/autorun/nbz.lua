if game.GetMap() ~= "gm_flatgrass" then return end

if SERVER then
	
	AddCSLuaFile("autorun/nbz.lua")
	
	local dontremove = { "info_player_start", "physgun_beam", "player", "predicted_viewmodel" }

	hook.Add("InitPostEntity", "NBZ", function()
		dissolver = ents.Create("env_entity_dissolver")
		dissolver:SetKeyValue("dissolvetype", 3)
		dissolver:SetKeyValue("magnitude", 5)
		dissolver:Spawn()
	end)
		
	hook.Add("Think", "NBZ", function()
		for _, ent in pairs(ents.FindInBox(Vector(768, -512, 30), Vector(1280, 512, 230))) do
			if not table.HasValue(dontremove, ent:GetClass()) and not ent.Dissolving then
				ent.Dissolving = true
				
				local dissolverTarget = "dissolve_" .. ent:EntIndex()
				ent:SetKeyValue("targetname", dissolverTarget)
				
				dissolver:SetPos(ent:GetPos())
				dissolver:Fire("Dissolve", dissolverTarget, 0)
			end
		end
	end)
	
end

if CLIENT then
	
	surface.CreateFont("coolvetica", 128, 400, true, false, "3dspawnfont")

	local r, g, b, a = 255, 40, 0, 50

	hook.Add("PostDrawOpaqueRenderables", "NBZ", function()
		
		-- Top
		cam.Start3D2D(Vector(768, -512, 31.2), Angle(0, 90, 0), 1)
			surface.SetDrawColor(r, g, b, a)
			surface.DrawRect(0, 0, 1024, 512)
		cam.End3D2D()
		
		-- Text
		cam.Start3D2D(Vector(960, 0, 32), Angle(0, 90, 0), 1)
			draw.DrawText("No Build Zone", "3dspawnfont", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end)
	
end