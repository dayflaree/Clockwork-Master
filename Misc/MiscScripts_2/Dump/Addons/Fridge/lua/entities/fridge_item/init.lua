AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		activator:SetHealth(activator:Health() + 20)
	end
	
	activator:SendLua('chat.AddText(Color(15, 248, 5, 255), "You have eaten from the Fridge!")')
	self:Remove()
end
