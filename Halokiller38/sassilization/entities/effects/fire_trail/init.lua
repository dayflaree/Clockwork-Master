function EFFECT:Init( data )
	
	self.Ent = data:GetEntity()
	
	if !ValidEntity( self.Ent ) then
		self.Ent = nil
		return
	end
	
	self.Sc = data:GetScale()
	self.Size = math.random(20,30)
	self.LifeTime = data:GetMagnitude()
	self.LifeTime = self.LifeTime and CurTime() + self.LifeTime or nil
	self.Mins = self.Ent:OBBMins()
	self.Maxs = self.Ent:OBBMaxs()
	self.Emitter = ParticleEmitter( self.Ent:GetPos() )
	
end

function EFFECT:Think( )
	
	if !self.Ent then return false end
	if !ValidEntity( self.Ent ) then self.Emitter:Finish() return false end
	if self.LifeTime and CurTime() > self.LifeTime then self.Emitter:Finish() return false end
	
	self.Size = math.Rand(6,10) * self.Sc
	
	for i=1,math.random(2,3) do
	
		local particle = self.Emitter:Add("effects/muzzleflash"..math.random(1,4), self.Ent:LocalToWorld( self.Ent:OBBCenter() )+Vector(math.Rand(self.Mins.x or 0,1),math.Rand(self.Mins.y or 0,1),math.Rand(self.Mins.z or 0,1))+Vector(math.Rand(-1,self.Maxs.x or 0),math.Rand(-1,self.Maxs.y or 0),math.Rand(-1,self.Maxs.z or 0)) )
	
		particle:SetVelocity(Vector(math.Rand(-3,3),math.Rand(-3,3),math.Rand(1,10)))
		particle:SetDieTime( math.Rand(.5,1) )
		particle:SetStartAlpha( math.Rand( 130, 150 ) )
		particle:SetEndAlpha(1)
		particle:SetStartSize( self.Size )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( -95, 95 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		particle:SetColor( math.Rand( 150, 255 ), math.Rand( 120, 150 ), 100 )
		
	end
	
	return true
	
end

function EFFECT:Render()

end
