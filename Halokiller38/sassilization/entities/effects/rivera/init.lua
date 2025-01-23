local dusties = {"one","two"}

function EFFECT:Init(data)
	self.Ent = data:GetEntity()
	if !data:GetEntity() or !data:GetEntity():IsValid() then return end
	local Pos = data:GetOrigin() + Vector( 0, 0, 8 )
	local Norm = data:GetNormal()
	self.Col = {}
	self.Col.r, self.Col.g, self.Col.b = data:GetEntity():GetColor()
	
	local LightColor = render.GetLightColor(Pos) * 255
		LightColor.r = math.Clamp( LightColor.r, 70, 255 )
		
	self.emitter = ParticleEmitter(Pos)
		local particle = self.emitter:Add("jaanus/build_sprites/dust_"..dusties[math.random(1,2)], Pos)
		particle:SetVelocity(Norm)
		particle:SetDieTime(math.Rand(1.0, 2.0))
		particle:SetStartAlpha(255)
		particle:SetStartSize(math.Rand( 16, 32))
		particle:SetEndSize(math.Rand( 32, 64))
		particle:SetRoll(math.Rand( 0, 360))
		particle:SetColor( self.Col.r, self.Col.g, self.Col.b, 100 )	
	
	self.DieTime = data.DieTime or CurTime() + 38
	self.Pos = Pos
end

function EFFECT:Think()
	if not self.DieTime then return false end
	if self.DieTime < CurTime() || !self.Ent:GetNWBool("spawning") then
		self.emitter:Finish()
		return false
	end
	if !self.Ent or !self.Ent:IsValid() then return false end
	local RandVel = VectorRand() * 16
	RandVel.z = 0
	local particle = self.emitter:Add("jaanus/build_sprites/dust_"..dusties[math.random(1,2)], self.Pos + RandVel)
	if particle then
		particle:SetVelocity(Vector(math.Rand(-15, 15), math.Rand(-15, 15), math.Rand(-6, -6)))
		particle:SetDieTime(1)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(10)
		particle:SetEndSize(0)
		particle:SetColor( self.Col.r, self.Col.g, self.Col.b, 255 )
	end

	self.Entity:NextThink( CurTime() + 1 )
	return true
end

function EFFECT:Render()
end
