include('shared.lua')

function ENT:Draw()
	
	self:DrawEntityOutline(0.0)
	self.Entity:DrawModel()
	
	if self:GetNWInt( "glowyitem" ) == 1 then
	local size = math.Clamp(TimedSin(5,60,70,10),5,25)
	render.SetMaterial( Material("effects/blueflare1") )
    render.DrawSprite( self.Entity:GetPos(), size, size, Color(0, 0, 250, 200) ) 
	end

end
