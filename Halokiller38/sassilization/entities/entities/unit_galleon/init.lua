AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Setup(pos)
	
	self.Entity:SetModel( UNITS[self.index].model )
	local size = 3
	--self.Entity:PhysicsInitBox( Vector( size * -1, size * -1, 0 ), Vector( size, size, size ) )
	--self.Entity:SetCollisionBounds( Vector( size * -1, size * -1, 0 ), Vector( size, size, size ) )
	self:SetSolid( SOLID_BBOX )
	self:SetMoveCollide( MOVECOLLIDE_FLY_SLIDE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:SetColor( 255, 255, 255, 255 )
	self.Entity:DrawShadow( true )

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion( false )
		phys:EnableGravity( false )
		phys:Sleep()
	end

	//Characteristics
	self.sails = true
	self.speed = 20
	self.Grounded = true
	self.targetheight = pos.z

	//Helping Collisions for Physics
	self.bounds = ents.Create("prop_physics")
	self.bounds:SetModel( self.Entity:GetModel() )
	self.bounds:DrawShadow(false)
	self.bounds:SetNoDraw(true)
	self.bounds:SetColor( 0, 255, 0, 255 )
	self.bounds:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.bounds:Spawn()
	self.bounds:Activate()
	self.bounds:SetPos( pos )
	self.bounds:GetPhysicsObject():EnableGravity( false )
	self.boundweld = constraint.Weld( self.Entity, self.bounds, 0, 0 )
	self.boundweld = constraint.NoCollide( self.Entity, self.bounds, 0, 0 )
	self.Entity:DeleteOnRemove( self.bounds )

end

function ENT:Animate()
	if self.Blasted then return end
	if self.Paralyzed then return end
	if self.Gravitated then return end
	if self.animtrans then return end
	self.animtrans = true
	local delay = .1
	if self.state == ANIM_IDLE then
		if self.index == 1 then
			self:SetAnim("idle")
			delay = 1.2
		elseif self.index == 2 then
			self:SetAnim("idle")
			delay = 1.2
		end
	end
	if self.state == ANIM_RUN then
		self:SetAnim("run")
		delay = .78
	end
	if self.state == ANIM_JUMP then
		self:SetAnim("jump")
		delay = 1.2
	end
	if self.state == ANIM_ATTACK then
		if self.index == 1 then
			self:SetAnim("swing")
			delay = 1.23
		elseif self.index == 2 then
			self:SetAnim("fire")
			delay = 2.03
		end
	end
	local function trans( args )
		if args[1].state == args[2] then
			args[1].animtrans = false
		end
	end
	timer.Simple( delay, trans, {self, self.state} )
end

function ENT:ExecuteUniqueMovement(phys)
	if self.Ordered and !self.sailing then
		self.sailing = true
		self.Grounded = true
		phys:EnableGravity(false)
		phys:EnableMotion(true)
		phys:Wake()
	end
	if self.Ordered and self.sailing then
		self.Grounded = true
		self.lastmove = CurTime() + 2
		self.Distance = self.Entity:GetPos():Distance( Vector( self.Target.x, self.Target.y, self.Entity:GetPos().z ) )
		if self.Distance <= 8 then
			self.Target = false
			self.Ordered = false
			self.Distance = 0
			self.BlockClock = false
		end
	end
	if !self.Ordered and self.sailing then
		if !self.lastmove || CurTime() > self.lastmove then
			self.lastmove = CurTime()
			self.Grounded = true
			self.sailing = false
		end
	end
	if !self.Grounded then
		phys:Wake()
		if !self.bounds then return end
		local physObj = self.bounds:GetPhysicsObject()
		if physObj and physObj:IsValid() then
			physObj:Wake()
		end
	end
	if self.Ordered then
		local trace = {}
		trace.start = self.Entity:GetPos() + self.Entity:GetForward()*10 + Vector( 0, 0, 100 )
		trace.endpos = self.Entity:GetPos() + self.Entity:GetForward()*10 + Vector( 0, 0, -200 )
		trace.filter = self.Entity
		trace.mask = MASK_SOLID_BRUSHONLY
		local tr = util.TraceLine(trace)
		if tr.HitPos.z > self.targetheight then
			self.sailing = false
			phys:ApplyForceCenter( self.Entity:GetForward()*-20 )
		else
			self.sailing = true
		end
	end
	self:GetTargetHeight()
end

function ENT:GetHeading(pos)
	if self.Target and !self.combatant then 
		self:LookAt( self.Target )
	end
	return Angle( 0, self.ang+90, 0 )
end

function ENT:TakeDamage( amount, attacker )
	self.LastEnemy = attacker
	if self.health/self.maxhealth <= .6 then
		if !self.broken then
			self.broken = 1
			self.speed = self.speed * 0.5
			local effectdata = EffectData()
				effectdata:SetMagnitude( 1 )
				effectdata:SetAngle( self.Entity:GetRight():Angle() )
				effectdata:SetOrigin( self.Entity:GetPos() + self.Entity:GetRight()*5 + self.Entity:GetUp()*4 )
			util.Effect( "gib_galleon", effectdata )
			self.Entity:SetModel("models/jaanus/galleon_halfbroken.mdl")
		end
	end
	if self.health/self.maxhealth <= .3 then
		if self.broken == 1 then
			self.broken = 2
			self.speed = 0
			local effectdata = EffectData()
				effectdata:SetMagnitude( 2 )
				effectdata:SetAngle( self.Entity:GetRight():Angle() )
				effectdata:SetOrigin( self.Entity:GetPos() + self.Entity:GetUp()*4 )
			util.Effect( "gib_galleon", effectdata )
			self.Entity:SetModel("models/jaanus/galleon_immobile.mdl")
		end
	end
end

function ENT:TraceEnemyEnt( entity )
	local dir = (entity:GetPos() - self.Entity:GetPos()):Normalize()
	local trace = {}
	trace.start = self.Entity:GetPos() + (Vector( dir.x, dir.y, 0 ) * 3 )
	trace.endpos = entity:GetPos() + Vector( 0, 0, 1.5 )
	trace.filter = {self, self.Entity, self.bounds}
	trace.filter = table.Add( trace.filter, player.GetAll() )
	local tr = util.TraceLine( trace )
	local insert = false
	local remove = false
	if (tr.Entity and tr.Entity == entity) || (table.HasValue( ents.FindInSphere( tr.HitPos, 3 ), entity ) and entity:IsUnit()) then
		if entity:GetPos():Distance( self.Entity:GetPos() ) >=self.minRange then
			insert = true
		end
	elseif entity == self.LastEnemy then
		remove = true
	end
	return insert, remove
end

function ENT:FindRangedEntities()
	return ents.FindInSphere( self.Entity:GetPos() + self.Entity:GetForward() * self.range/4, self.range )
end

function ENT:AttackSound( enemy )
	self.Entity:EmitSound( "sassilization/units/arrowfire0"..math.random( 1,2 )..".wav" )
end

function ENT:DoAttack( enemies )
	local enemy = enemies[1]
	if self.LastEnemy then
		enemy = self.LastEnemy
	end
	self:LookAt( enemy:GetPos() )
	enemy:DealDamage( self.damage, self )
	local spos = self.Entity:GetPos() + Vector( 0, 0, 2 )
	local epos = enemy:GetPos() + Vector( 0, 0, 1.6 )
	local ang = (epos - spos):Normalize():Angle()
	ang.y = self.ang
	self:shootArrow( self.Entity:GetPos() + Vector( 0, 0, 2 ), enemy:GetPos() + Vector( 0, 0, 1.5 ), ang )
end

function ENT:DoDeath()
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetScale( 6 )
		effectdata:SetMagnitude( GIB_WOOD )
	util.Effect( "gib_structure", effectdata )
	local effectdata = EffectData()
		effectdata:SetMagnitude( 3 )
		effectdata:SetAngle( self.Entity:GetRight():Angle() )
		effectdata:SetOrigin( self.Entity:GetPos() + self.Entity:GetRight()*10 )
	util.Effect( "gib_galleon", effectdata )
	local effectdata = EffectData()
		effectdata:SetMagnitude( 4 )
		effectdata:SetAngle( self.Entity:GetRight():Angle() )
		effectdata:SetOrigin( self.Entity:GetPos() - self.Entity:GetRight()*10 )
	util.Effect( "gib_galleon", effectdata )
	self.Overlord:SendLua("playsound('sassilization/units/unitLost.wav', 3)")
end
function ENT:GetTargetHeight()
	local trace = {}
	trace.start = self.Entity:GetPos() + Vector( 0, 0, 10 )
	trace.endpos = self.Entity:GetPos() + Vector( 0, 0, -200 )
	trace.filter = self.Entity
	trace.mask = MASK_WATER
	local tr = util.TraceLine(trace)
	if tr.HitPos and tr.HitWorld and tr.Fraction ~= 1 then
		self.targetheight = tr.HitPos.z
		self.Entity:GetPhysicsObject():EnableGravity(false)
	else
		self.sailing = false
		self.Entity:GetPhysicsObject():EnableGravity(true)
	end
end

function ENT:PhysicsUpdate( phys )
	local angvel = phys:GetAngleVelocity()
	phys:AddAngleVelocity( Vector(angvel.x*-1, angvel.y*-1,angvel.z*-1) )
	local dir;
	local up;
	if self.Target and self.sailing and !self.combatant then
		dir = (self.Target - self.Entity:GetPos()):Normalize()
		dir = (self.Entity:GetRight()+dir)*0.5
	else
		dir = {x=0,y=0}
	end
	if self.Entity:GetPos().z < self.targetheight - 2 then
		up = 5
	elseif self.Entity:GetPos().z > self.targetheight + 2 then
		up = -5
	else
		up = 0
	end
	phys:SetVelocity(Vector(dir.x,dir.y,0)*self.speed+Vector(0, 0, up))
end