AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:HoverInfo({icon = 'page', info = 'Notepad'})
	self.Entity:SetUseType(SIMPLE_USE)
	self.Entity:SetModel("models/props_lab/clipboard.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
 
    local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use(activator, caller)
	umsg.Start("lob_notepad", activator)
		umsg.String("Welcome to the Team Equinox Lobby. Enjoy your stay!")
	umsg.End()
end
