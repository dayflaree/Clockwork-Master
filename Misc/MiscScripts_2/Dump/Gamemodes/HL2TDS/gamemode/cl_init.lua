require("datastream")

include('shared.lua')

GM.CamPos = Vector(0, 0, 0)
GM.CamHeight = 500

function GM:HUDPaint()
	-- self.BaseClass:HUDPaint()
end

function GM:CalcView(ply, origin, angles, fov)
	local view = {}
	view.origin = self.CamPos
	view.angles = Angle(90, 0, 0)
	view.fov = 90
	
	return view
end

function GM:ShouldDrawLocalPlayer()
	return true
end

function GM:Think()
	-- Cursor Enabled
	if not vgui.CursorVisible() then
		gui.EnableScreenClicker(true)
	end
	
	-- Camera Location
	local tr = util.QuickTrace(LocalPlayer():GetShootPos(), Vector(0, 0, 1) * self.CamHeight, LocalPlayer())
	self.CamPos = tr.HitPos
	
	-- Cursor Aim
	local tr = util.QuickTrace(self.CamPos, gui.ScreenToVector(gui.MousePos()) * 1000)
	LocalPlayer():SetEyeAngles((tr.HitPos - LocalPlayer():GetShootPos()):Angle())
end

function GM:GUIMousePressed(mc, vec)
	if mc == MOUSE_LEFT then
		RunConsoleCommand("+attack")
	end
	
	if mc == MOUSE_RIGHT then
		RunConsoleCommand("+attack2")
	end
end

function GM:GUIMouseReleased(mc)
	if mc == MOUSE_LEFT then
		RunConsoleCommand("-attack")
	end
	
	if mc == MOUSE_RIGHT then
		RunConsoleCommand("-attack2")
	end
end