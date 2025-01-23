//Credit to JetBoom for this effect.

EFFECT.Time = math.Rand(5, 10)

function EFFECT:Init(data)
	local modelid = data:GetScale()
	self.type = math.Round(tonumber(data:GetMagnitude()))

	if self.type == GIB_STONE then
		self.Entity:SetModel(Gibs_Stone[modelid])
	elseif self.type == GIB_WOOD then
		self.Entity:SetModel(Gibs_Wood[modelid])
	end

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	
	if self.type == GIB_WOOD then
		self.Entity:SetSolid( SOLID_BBOX )
		self.Entity:SetCollisionBounds( Vector() * -12, Vector() * 12 )
		self.Entity:SetModelScale( Vector( .5, .5, .5 ) )
	end
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetAngle(Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360)))
		if self.type == GIB_STONE then
			phys:ApplyForceCenter(VectorRand() * math.Rand(20, 60))
		else
			phys:ApplyForceCenter(VectorRand() * math.random(150, 200))
		end
	end
	self.Time = RealTime() + math.random(8, 12)
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
	self.setup = ValidEntity( self.Entity )
end

function EFFECT:Think()
	if !self.setup then
		self.Emitter:Finish()
		return false
	end
	if RealTime() > self.Time then
		self.Emitter:Finish()
		return false
	end
	return true
end

function EFFECT:Render()
	if !self.setup then return end
	self.Entity:DrawModel()
	if self.Entity:GetVelocity():Length() > 10 and self.Entity:WaterLevel() == 0 and self.type == GIB_WOOD then
		local particle = self.Emitter:Add("particles/flamelet"..math.random(1,4), self.Entity:GetPos())
		particle:SetVelocity(VectorRand() * 16)
		particle:SetDieTime(0.6)
		particle:SetStartAlpha(255)
		particle:SetStartSize(18)
		particle:SetEndSize(8)
		particle:SetRoll(180)
		particle:SetColor(80, 80, 80)
		particle:SetLighting(true)
	end
end
