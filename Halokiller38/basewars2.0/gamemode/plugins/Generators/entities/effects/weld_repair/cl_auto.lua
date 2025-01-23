function EFFECT:Init(data)

	self.StartPos = data:GetStart() 
    self.EndPos = data:GetOrigin()
    self.Scale = data:GetScale() or 1
    self.Delay = 0.2 * self.Scale
	self.Normal = data:GetNormal();
    self.EndTime = CurTime()+self.Delay
    self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
    local emi = ParticleEmitter( self.EndPos )
	for i = 1, 5 do
		local particle = emi:Add("effects/energysplash", self.EndPos)
		particle:SetColor(189,189,255,255)
		particle:SetVelocity(VectorRand()*400+self.Normal:Angle():Forward()*300)
		particle:SetDieTime(0.25);
		particle:SetStartSize(3)
		particle:SetEndSize(0)
		particle:SetStartLength(10)
		particle:SetEndLength(0)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetGravity(Vector(0,0,-800))
		particle:SetCollide(true)
		particle:SetBounce(0.8)
	end

		local dlightend = DynamicLight(0)
			dlightend.Pos            = self.EndPos
			dlightend.Size            = 100
			dlightend.Decay            = 100
			dlightend.R                = 175
			dlightend.G                = 175
			dlightend.B                = 255
			dlightend.Brightness   	= 2
			dlightend.DieTime        = CurTime() + self.Delay*5
    emi:Finish()
	
	//Glow
	local emi = ParticleEmitter( self.EndPos )
	local particle = emi:Add("sprites/light_glow02_add", self.EndPos)
	particle:SetVelocity(VectorRand()*math.random(75, 125))
	particle:SetDieTime(0.75)
	particle:SetStartAlpha(255)
	particle:SetStartSize(10)
	particle:SetEndSize(0)
	particle:SetEndAlpha(0)
	particle:SetAirResistance(5000)
	particle:SetRoll(math.Rand(1, 90))
	particle:SetRollDelta(math.random( 0, 5 ))
	particle:SetGravity(Vector( 0, 0, 0))
	particle:SetCollide(true)
	particle:SetBounce(0)
	particle:SetColor(160, 160, 255)
    emi:Finish()
	
end

function EFFECT:Think()
    if self.EndTime<CurTime() then 
        --self:Remove()
        return false
    else
        return true
    end
end

function EFFECT:Render()
     self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )    
end