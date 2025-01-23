include('shared.lua')

local laserMat = Material( "cable/blue_elec" )
local glowSpr = Material( "effects/energyball" )

function ENT:Draw() end

function ENT:DrawTranslucent()
	
	local distance = self.Entity:GetPos():Distance( EyePos() )
	if distance < 1000 then
		
		self.Entity:DrawModel()
		
		local height = self.Entity:OBBMaxs().z
		local pos = self.Entity:GetPos() + self.Entity:GetUp() * height
		
		render.SetMaterial( glowSpr )
		render.DrawSprite( pos, 6, 6, Color( 95, 250, 240, 255 ) )
		render.SetMaterial( laserMat )
		
		for _, ent in pairs( ents.FindInSphere( pos, 40 ) ) do
			if ent:GetClass() == "bldg_shieldmono" then
				local r,g,b,a = ent:GetColor()
				if a >= 255 then
					render.DrawBeam( pos, ent:GetPos()+ent:GetUp()*height, 2 + math.sin(CurTime() / 3), 0, 0, Color( 255, 255, 255, math.Min( 255, 150 + math.sin(CurTime() / 3) * 50 ) ) )
				end
			end
		end
		
	else return end
	
end