require("datastream")

include('shared.lua')

GM.CamPos = Vector(0, 0, 1000)

GM.Cursor = {}
GM.Cursor.WorldPos = Vector(0, 0, 0)
GM.Cursor.HitNormal = Vector(0, 0, 0)

GM.Selection = {}
GM.Selection.Start = { x = 0, y = 0 }
GM.Selection.End = { x = 0, y = 0 }

GM.Placement = {}
GM.Placement.CurrentItem = nil

local cursormat = Material("sprites/blueglow2")

function GM:HUDPaint()
	if self.Selection.Start.x > 0 then
		self.Selection.End.x, self.Selection.End.y = gui.MousePos()
	end
	
	surface.SetDrawColor(255, 255, 255, 100)
	surface.DrawRect(
		math.Min(self.Selection.Start.x, self.Selection.End.x),
		math.Min(self.Selection.Start.y, self.Selection.End.y),
		math.Dist(
			math.Min(self.Selection.Start.x, self.Selection.End.x),
			0,
			math.Max(self.Selection.Start.x, self.Selection.End.x),
			0
		),
		math.Dist(
			math.Min(self.Selection.Start.y, self.Selection.End.y),
			0,
			math.Max(self.Selection.Start.y, self.Selection.End.y),
			0
		)
	)
	
	surface.SetDrawColor(100, 100, 100, 255)
    surface.DrawOutlinedRect(
		math.Min(self.Selection.Start.x, self.Selection.End.x),
		math.Min(self.Selection.Start.y, self.Selection.End.y),
		math.Dist(
			math.Min(self.Selection.Start.x, self.Selection.End.x),
			0,
			math.Max(self.Selection.Start.x, self.Selection.End.x),
			0
		),
		math.Dist(
			math.Min(self.Selection.Start.y, self.Selection.End.y),
			0,
			math.Max(self.Selection.Start.y, self.Selection.End.y),
			0
		)
	)
end

function GM:PreDrawOpaqueRenderables()
	cam.Start3D(self.CamPos, Angle(90, 0, 0))
        render.SetMaterial(cursormat)
        render.DrawQuadEasy(
			self.Cursor.WorldPos + self.Cursor.HitNormal,
			self.Cursor.HitNormal,
			128, 128,
			Color(255, 255, 255, 255),
			0
        ) 
    cam.End3D()
end

function GM:GUIMousePressed(mc, av)
	self.Selection.Start.x, self.Selection.Start.y = gui.MousePos()
end

function GM:GUIMouseReleased(mc, av)
	self.Selection.Start.x, self.Selection.Start.y = 0, 0
	self.Selection.End.x, self.Selection.End.y = 0, 0
end

function GM:Initialize()
	local p = vgui.Create("DPropertySheet")
	p:SetPos(20, ScrH() - 220)
	p:SetSize(ScrW() - 40, 200)
	
	local buildsheet = vgui.Create("DPanel")
	
	local structures = vgui.Create("DPanelList", buildsheet)
	structures:SetSpacing(5)
	structures:SetPadding(5)
	structures:EnableHorizontal(true)
	structures:EnableVerticalScrollbar(true)
	structures:Dock(FILL)
	
	for _, BUILDING in pairs(self.Buildings) do
		local item = vgui.Create("DModelPanel")
		item:SetSize(64, 64)
		item:SetModel(BUILDING.Model)
		item:SetToolTip(BUILDING.Name)
		
		local PrevMins, PrevMaxs = item.Entity:GetRenderBounds()
		item:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.75, 0.75, 0.5))
		item:SetLookAt((PrevMaxs + PrevMins) / 2)
		
		item.DoClick = function()
			self.Placement.CurrentItem = BUILDING.Name
			RunConsoleCommand("placement", BUILDING.Name)
		end
		
		structures:AddItem(item)
	end
	
	p:AddSheet("Creation", buildsheet, "gui/silkicons/application_view_tile", false, false, "Build Stuff!")
	
	local r = vgui.Create("DButton")
	r:SetSize(60, 20)
	r:SetPos(ScrW() - 80, ScrH() - 222)
	r:SetText("Return")
	r:SetToolTip("Return to your starting point")
	r.DoClick = function()
		self.CamPos = Vector(0, 0, 1000)
	end
end

function GM:CalcView(ply, origin, angles, fov)
	local view = {}
	view.origin = self.CamPos
	view.angles = Angle(90, 0, 0)
	view.fov = 90
	
	return view
end

function GM:ShouldDrawLocalPlayer()
	return false
end

function GM:Think()
	-- Cursor Enabled
	if not vgui.CursorVisible() then
		gui.EnableScreenClicker(true)
	end
	
	-- Cursor Aim
	local tr = util.QuickTrace(self.CamPos, gui.ScreenToVector(gui.MousePos()) * 4096 * 4)
	
	self.Cursor.WorldPos = tr.HitPos
	self.Cursor.HitNormal = tr.HitNormal
	
	local x, y = gui.MousePos()
	
	if x < 10 then
		self.CamPos = self.CamPos + Vector(0, 5, 0)
	elseif x > ScrW() - 10 then
		self.CamPos = self.CamPos - Vector(0, 5, 0)
	end
	
	if y < 10 then
		self.CamPos = self.CamPos + Vector(5, 0, 0)
	elseif y > ScrH() - 10 then
		self.CamPos = self.CamPos - Vector(5, 0, 0)
	end
end

function GM:HUDShouldDraw(name)
	return not table.HasValue({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudWeaponSelection"}, name)
end