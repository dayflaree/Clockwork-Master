AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.PrecacheModel( "models/jaanus/muchsmallerbrick.mdl" )
util.PrecacheModel( "models/jaanus/smallerflag.mdl" )

function ENT:OnDamaged() end

function ENT:DealDamage( amount, attacker )
	if !(ValidEntity( self ) and !self:IsDead()) then return end
	if !(ValidEntity( attacker ) and !attacker:IsDead()) then return end
	self:OnDamaged( amount )
	self.lastAttacked = 1
	if self.health - amount > 0 then
		self.health = self.health - amount
		self.Entity:SetNWInt( "health", self.health )
		if !self:GetOverlord() then return end
		if !self:IsReady() then return end
		local r,g,b,a = self:GetOverlord():GetColor()
		local d = self.clamp - ( self.clamp * math.Clamp( self.health , 0 , self.maxhealth ) / self.maxhealth )
		r = r + d
		g = g + d
		b = b + d
		self.Entity:SetColor( r,g,b,a )
	else
		self:Raze( "death", attacker:GetOverlord() )
		attacker.Clock = 1
		if attacker:GetClass() == "unit" or attacker:GetClass() == "tower" then
			attacker.combatant = false
		elseif attacker:GetClass() == "arrow" then
			attacker.Predict = false
			attacker:GetPhysicsObject():EnableGravity( true )
			attacker:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			local phys = attacker:GetPhysicsObject()
			phys:EnableMotion(true)
			phys:Wake()
		end
	end
	if self.health < self.maxhealth*0.5 then
		if !self.lastfire or CurTime() > self.lastfire then
			local effectdata = EffectData()
				effectdata:SetEntity( self )
				effectdata:SetScale( 1 )
				effectdata:SetMagnitude( self.health )
			util.Effect( "fire_trail", effectdata, 1, 1 )
			self.lastfire = CurTime() + self.health
		end
	end
end

function ENT:SetSpawner(ply)
	self.SpawnedBy = ply
	if self.claimed then return end
	if ply:IsPlayer() then
		if !self.nocolor then
			self.Entity:SetColor( ply:GetColor() )
		end
		self.claimed = true
		self.Overlord = ply
		self.combatant = true
		self:SetOwner( ply )
		local r,g,b,a = ply:GetColor()
		self:GetClamp( r, g, b )
	end
end

function ENT:IsUpgraded()
	return self.upgraded
end