include('shared.lua')

function ENT:Draw()
	if self.Entity:GetPos():Distance( LocalPlayer():GetPos() ) < 1000 then
		self.Entity:DrawModel()
	end
end