ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Barbed Wire"
ENT.Author = "_Undefined"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then

	function ENT:Initialize()
        self:SetModel("models/props_barbedwire/barbedwire_high01.mdl")
        self:PhysicsInit(SOLID_OBB)
		self:SetMoveType(MOVETYPE_NONE)
    end
	
	function ENT:StartTouch(ent)
		if ent and ent:IsValid() and ent:IsPlayer() then
			ent:TakeDamage(25, self, self)
			ent:SetVelocity((ent:GetForward() * -300) + Vector(0, 0, 50))
		end
	end
    
end

if CLIENT then

	language.Add("barbed_wire", "Barbed Wire")
	
	function ENT:Draw()
		self:DrawModel()
	end
	
end