AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.Text = "Build Server"

function ENT:Initialize()
	self.Entity:SetModel("models/dav0r/hoverball.mdl")
	self.Entity:SetColor(255, 255, 255, 1)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	
	timer.Create("set_3d_logo_text", 60, 0, function() self:SetText() end)
end

function ENT:SetText(text)
	if not text then text = self.Text end
	
	umsg.Start("3d_logo_text", player.GetAll())
		umsg.String(text)
	umsg.End()
end