ENT.Type = "anim";
ENT.Base = "prop_thumper";
ENT.PrintName = "";
ENT.Author = "";
ENT.Purpose = "";
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.On = true

function ENT:Use()
	if self.On then
		self:Fire("Disable")
	else
		self:Fire("Enable")
	end
end