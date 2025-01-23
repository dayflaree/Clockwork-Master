ENT.Base			= "base_anim"
ENT.Type			= "anim"

ENT.PrintName		= "Fish"
ENT.Author			= "SuperSpecialSenior (mr no no)"
ENT.Contact			= "imhenrythe8thim@yahoo.com"
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false // false makes this sent admin only
ENT.AdminSpawnable 	= true

function ENT:OnRemove()
	if SERVER then
		// To prevent the console from being spammed with errors
		hook.Remove("Think",self.Entity:EntIndex().."fishfadeout")
	end
end

function ENT:PhysicsCollide(data, physobj)
	if SERVER then
		if self.Entity:WaterLevel() > 0 then
			local vec = VectorRand()
			self.Entity:SetAngles(self.Entity:GetAngles() + vec:Angle())
		end
	end
end
