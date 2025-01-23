include('shared.lua')

function ENT:Draw()
	
	local distance = self.Entity:GetPos():Distance( LocalPlayer():GetPos() )
	local r,g,b,a = self:GetOwner():GetColor()
	local color = Color( self:GetColor() )
	if distance < 1000 then
		a = math.Clamp( (200 - math.Max( distance - 800, 0 )) / 200 * 255, 1, 255 )
		if a != 255 then
			self.Entity:SetColor( r, g, b, a )
		elseif color.a != 255 then
			self.Entity:SetColor( r, g, b, 255 )
		end
		self.Entity:DrawModel()
	end
	
end