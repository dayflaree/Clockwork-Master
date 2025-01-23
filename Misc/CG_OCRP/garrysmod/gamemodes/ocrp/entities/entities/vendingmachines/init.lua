AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props/cs_office/vending_machine.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.OwnerType = "Mayor"
end

function ENT:KeyValue(key,value)
end

function ENT:SetType(strType)
end

function ENT:Use(ply, caller)
	if ply:IsPlayer() && !ply.CantUse then
			umsg.Start("OCRP_CreateChat", ply)
			umsg.String( 30 )
			umsg.Bool( true )
			umsg.End()					
		ply.CantUse = true
		timer.Simple(0.3, function() ply.CantUse = false end)
	end
end
