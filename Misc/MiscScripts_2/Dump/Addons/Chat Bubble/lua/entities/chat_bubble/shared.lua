AddCSLuaFile("shared.lua")

ENT.Type = "anim"

ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:Draw()
	local owner = self:GetNWEntity("player")
	
	if owner and owner:IsValid() then
		self:SetPos(owner:GetPos() + Vector(0, 0, 90))
	end
	
	self:SetAngles(Angle(0, UnPredictedCurTime() * 100, 0))
	self:DrawModel()
end

function ENT:Initialize()
	self:SetModel("models/extras/info_speech.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
end