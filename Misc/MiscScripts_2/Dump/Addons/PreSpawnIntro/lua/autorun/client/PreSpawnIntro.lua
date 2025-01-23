hook.Add("Initialize", "ESFonts", function() surface.CreateFont("coolvetica", 70, 400, true, false, "ESButtonFont") end)

function PreSpawnIntroCam(ply, origin, angles, fov)
	if LocalPlayer().PreSpawnIntro == true then
		local AimPos = Vector(1010, 0, 0)
		local LastAngles = LastAngles or angles
		
		local AimNormal = AimPos - LocalPlayer():GetShootPos()
		AimNormal:Normalize()
		
		angles = AimNormal:Angle()
		
		LastAngles = angles
		
		local view = {}
		view.origin = Vector(1010, 0, 200) + 1500 * Angle(0, CurTime() * 6, 0):Forward() + (Vector(0, 0, 1) * math.sin(CurTime() * 0.2) * 150)
		view.angles = angles
		view.fov = fov
		
		return view
	end
end
hook.Add("CalcView", "PreSpawnIntroCam", PreSpawnIntroCam)

function PreSpawnIntroDraw()
	if LocalPlayer().PreSpawnIntro == true then
		surface.SetDrawColor(0, 0, 0, 220)
		surface.DrawRect(0, 0, ScrW(), ScrH())
		if not vgui.CursorVisible() then
			gui.EnableScreenClicker(true)
		end
	end
end
hook.Add("HUDPaint", "PreSpawnIntroDraw", PreSpawnIntroDraw)

usermessage.Hook("PreSpawnIntro", function(um)
	local bool = um:ReadBool()
	LocalPlayer().PreSpawnIntro = bool
	gui.EnableScreenClicker(bool)
	
	if bool then
		--[[
		local PS = vgui.Create("DPropertySheet")
		PS:SetPos(ScrW() / 2 - 300, ScrH() / 2 + 50)
		PS:SetSize(600, 350)
		
		local WelcomeDP = vgui.Create("DPanel")
		
		local MotdH = vgui.Create("HTML", WelcomeDP)
		MotdH:SetSize(585, 330)
		MotdH:SetPos(5, 5)
		MotdH:OpenURL("http://www.garrysmod.com")
		MotdH:StartAnimate(100)
		
		local SettingsDP = vgui.Create("DPanel")
		
		local DMP = vgui.Create("DModelPanel", SettingsDP)
		DMP:SetModel(LocalPlayer():GetModel())
		DMP:SetSize(330, 330)
		DMP:SetCamPos(Vector(50, 50, 100))
		DMP.Animation = afk_anim
		DMP.LayoutEntity = function()
			DMP.Entity:SetSequence(DMP.Entity:LookupSequence(DMP.Animation))
			DMP:RunAnimation()
		end
		
		local anims = {
			"lineidle01",
			"lineidle02",
			"lineidle03",
			"lineidle04",
			"lookoutidle",
			"sit_ground",
			"cower_idle",
			"crouchidlehide",
			"idle_angry",
			"injured1",
			"luggageidle",
			"lying_down",
			"roofidle2",
			"scaredidle"
		}
		
		local AnimationDMC = vgui.Create("DMultiChoice", SettingsDP)
		AnimationDMC:SetPos(340, 5)
		AnimationDMC:SetSize(240, 20)
		AnimationDMC:SetEditable(false)
		for _, anim in pairs(anims) do
			AnimationDMC:AddChoice(anim)
		end
		AnimationDMC:SetText(afk_anim)
		AnimationDMC.OnSelect = function(index, value, data)
			DMP.Animation = data
			RunConsoleCommand("afk_anim", data)
		end
		
		PS:AddSheet("Welcome", WelcomeDP, "gui/silkicons/star", false, false, "Rules and MOTD")
		PS:AddSheet("Settings", SettingsDP, "gui/silkicons/wrench", false, false, "Configure your settings")
		
		local ContinueDB = vgui.Create("DButton")
		ContinueDB:SetSize(100, 30)
		ContinueDB:SetPos(ScrW() / 2 + 200, ScrH() / 2 + 405)
		ContinueDB:SetText("Continue >")
		ContinueDB.DoClick = function()
			RunConsoleCommand("ClosePreSpawnIntro")
			PS:Remove()
			ContinueDB:Remove()
		end
		
		]]--
		
		ESSpawn = vgui.Create("DButton")
		ESSpawn:SetPos((ScrW() / 2) - 200, (ScrH() / 2) + 50)
		ESSpawn:SetSize(400, 100)
		ESSpawn:SetText("")
		ESSpawn.DoClick = function()
			RunConsoleCommand("ClosePreSpawnIntro")
			ESSpawn:Remove()
			if ESSpawnA then
				ESSpawnA:Remove()
			end
		end
		ESSpawn.Paint = function()
			if LocalPlayer().PreSpawnIntro == true then
				draw.SimpleText("Join Game", "ESButtonFont", 200, 50, Color(5, 147, 237, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end)