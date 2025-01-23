AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Setup(pos)
	
	self:SetModel( UNITS[self.index].model )
	self:PhysicsInit(SOLID_OBB_YAW)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_BBOX )
	self:SetMoveCollide( MOVECOLLIDE_FLY_SLIDE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetColor( 255, 255, 255, 255 )
	self:DrawShadow( false )
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion( false )
		phys:EnableGravity( false )
		phys:EnableDrag( false )
		phys:Sleep()
	end
	
	//Characteristics
	self.flies = true
	self.Grounded = true
	self.targetheight = pos.z
	
	//Helping Collisions for Physics
	self.bounds = ents.Create("prop_physics")
	self.bounds:SetModel( self:GetModel() )
	self.bounds:DrawShadow(false)
	self.bounds:SetNoDraw(true)
	self.bounds:SetColor( 0, 255, 0, 255 )
	self.bounds:SetMoveCollide( MOVECOLLIDE_FLY_SLIDE )
	self.bounds:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.bounds:Spawn()
	self.bounds:Activate()
	self.bounds:SetPos( pos )
	self.bounds:GetPhysicsObject():EnableGravity( false )
	self.boundweld = constraint.Weld( self, self.bounds, 0, 0 )
	self.boundweld = constraint.NoCollide( self, self.bounds, 0, 0 )
	self:DeleteOnRemove( self.bounds )
	
end

function ENT:ExecuteUniqueMovement(phys)
	self:LookAt( self.Target )
	self:SetAngles( Angle( 0, self.ang or 0, 0 ) )
	if ValidEntity( self.bounds ) then
		self.bounds:SetAngles( Angle( 0, self.ang or 0, 0 ) )
	end
	if self.Ordered and !self.flying then
		self.flying = true
		self.Grounded = false
		phys:EnableGravity(false)
		phys:EnableMotion(true)
		phys:Wake()
	end
	if self.Ordered and self.flying then
		self.Grounded = false
		self.lastmove = CurTime() + 2
		self.Distance = self:GetPos():Distance( Vector( self.Target.x, self.Target.y, self:GetPos().z ) )
		if self.Distance <= 8 then
			self.Target = false
			self.Ordered = false
			self.Distance = 0
			self.BlockClock = false
		end
	end
	if !self.Ordered and self.flying then
		if !self.lastmove || CurTime() > self.lastmove then
			self.lastmove = CurTime()
			self.Grounded = false
			self.flying = false
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
	self:GetTargetHeight()
end

function ENT:GetHeading(pos)
	if self.Target and !self.combatant then 
		self:LookAt( self.Target )
	end
	return Angle( 0, self.ang, 0 )
end

function ENT:TakeDamage( amount, attacker )
	self.LastEnemy = attacker
end

function ENT:TraceEnemyEnt( entity )
	local dir = (entity:GetPos() - self:GetPos()):Normalize()
	local trace = {}
	trace.start = self:GetPos() + (Vector( dir.x, dir.y, 0 ) * 3 )
	trace.endpos = entity:GetPos() + Vector( 0, 0, 1.5 )
	trace.filter = {self, self, self.bounds}
	trace.filter = table.Add( trace.filter, player.GetAll() )
	local tr = util.TraceLine( trace )
	local insert = false
	local remove = false
	if ( ValidEntity( tr.Entity ) and tr.Entity == entity) || (table.HasValue( ents.FindInSphere( tr.HitPos, 3 ), entity ) and entity:IsUnit()) then
		if entity:GetPos():Distance( self:GetPos() ) >=self.minRange then
			insert = true
		end
	elseif entity == self.LastEnemy then
		remove = true
	end
	return insert, remove
end

function ENT:FindRangedEntities()
	return ents.FindInSphere( self:GetPos() + self:GetDirection() * self.range/4, self.range )
end

function ENT:AttackSound( enemy )
	self:EmitSound( "sassilization/units/arrowfire0"..math.random( 1,2 )..".wav" )
end

function ENT:DoAttack( enemies )
	local enemy = enemies[1]
	if self.LastEnemy then
		enemy = self.LastEnemy
	end
	self:LookAt( enemy:GetPos() )
	enemy:DealDamage( self.damage, self )
	local spos = self:GetPos() + Vector( 0, 0, 2 )
	local epos = enemy:GetPos() + Vector( 0, 0, 1.6 )
	local ang = (epos - spos):Normalize():Angle()
	ang.y = self.ang
	self:shootArrow( self:GetPos() + self:GetDirection()*4 + Vector( 0, 0, 2 ), enemy:GetPos() + Vector( 0, 0, 1.5 ), ang )
end

function ENT:DoDeath()
	local effectdata = EffectData()
		effectdata:SetStart( Vector(200, 200, 200) )
		effectdata:SetOrigin( self:GetPos()+Vector(0, 0, 20) )
	util.Effect( "balloon_pop", effectdata )
	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos())
	util.Effect( "gib_swag", effectdata )
	local archer = ents.Create("unit_archer")
	archer:SetPos(self:GetPos())
	archer.falling = true
	archer.index = 2
	archer:Spawn()
	archer:Activate()
	archer:SetSpawner(self.Overlord)
	if self.WasSelected then
		archer:Select(self.Overlord)
	end
	self.Overlord:SendLua("playsound('sassilization/units/unitLost.wav', 3)")
	constraint.RemoveAll( self )
end

function ENT:GetTargetHeight()
	local trace = {}
	trace.start = self:GetPos() + Vector( 0, 0, 10 )
	trace.endpos = self:GetPos() + Vector( 0, 0, -200 )
	trace.filter = self
	trace.mask = MASK_WATERWORLD
	local tr = util.TraceLine(trace)
	if tr.HitPos and tr.HitWorld then
		if self.flying then
			self.targetheight = tr.HitPos.z + 40
		else
			self.targetheight = self:GetPos().z - 10
		end
	else
		self.targetheight = self:GetPos().z - 200
	end
end

function ENT:PhysicsCollide( data, phys )
	if data.HitEntity:IsWorld() and !self.flying then
		if ( data.HitNormal:Angle().p <= 110 && data.HitNormal:Angle().p >= 65 ) then
			self.Grounded = true
			phys:Sleep()
			phys:EnableGravity(true)
			phys:EnableMotion(false)
			if !self.bounds then return end
			local physObj = self.bounds:GetPhysicsObject()
			if physObj and physObj:IsValid() then
				physObj:Sleep()
			end
		end
	end
end

function ENT:PhysicsUpdate( phys )
	local angvel = phys:GetAngleVelocity()
	phys:AddAngleVelocity( Vector(angvel.x*-1, angvel.y*-1,angvel.z*-1) )
	local dir;
	local up;
	if self.Target and !self.combatant then
		dir = (self.Target - self:GetPos()):Normalize()
	else
		dir = {x=0,y=0}
	end
	if self:GetPos().z < self.targetheight - 2 then
		up = 50
	elseif self:GetPos().z > self.targetheight + 2 then
		up = -5
	else
		up = 0
	end
	phys:SetVelocity(Vector(dir.x,dir.y,0)*12*self.speed+Vector(0, 0, up))
end