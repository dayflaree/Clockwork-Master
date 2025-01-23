include('shared.lua')

function ENT:Draw()
	
	local distance = self.Entity:GetPos():Distance( LocalPlayer():GetPos() )
	if distance < 1000 then
		self.Entity:DrawModel()
	end
	
end