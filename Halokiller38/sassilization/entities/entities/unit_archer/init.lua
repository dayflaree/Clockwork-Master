AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


function ENT:Setup()
	
	self:SetModel( UNITS[self.index].model )
	
	self:PhysicsInitSphere( self.size * 0.5 )
	self:SetCollisionBounds( Vector()*self.size*-0.5, Vector()*self.size*0.5 )
	self:SetMoveCollide( MOVECOLLIDE_FLY_SLIDE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:DrawShadow( false )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion( true )
		phys:Wake()
	end
	
	self:StartMotionController()

	//Characteristics
	self.fleshy = true

end

function ENT:Animate()
	
	if self:GetNWBool( "paralyzed" ) then return end
	if self:GetNWBool( "gravitated" ) then return end
	
	self.animtrans = self.animtrans or CurTime()
	if CurTime() < self.animtrans then return end
	
	local delay = .1
	if self:GetState() == ANIM_IDLE then
		self:SetAnim("idle")
		delay = 1.2
	end
	if self:GetState() == ANIM_RUN then
		self:SetAnim("run")
		delay = .75
	end
	if self:GetState() == ANIM_JUMP then
		self:SetAnim("jump")
		delay = 1.2
	end
	if self:GetState() == ANIM_ATTACK then
		self:SetAnim("fire")
		delay = 2.03
	end
	
	self.animtrans = CurTime() + delay
	
end

function ENT:GetHeading(pos)
	if self.Target and !self.combatant then 
		self:LookAt( self.Target )
		if self.Normal then
			local ay = self.Target.y - pos.y
			local ax = self.Target.x - pos.x
			local rad = math.atan2( ay, ax )
			local dp = Vector( math.cos( rad ), math.sin( rad ), 0 ):DotProduct( self.Normal ) * -1
			self.pitch = 360 - (( self.Normal:Angle().p - 270 ) * dp * 2)
			local lift = dp * 200
			self.roll = self.Normal:Angle().r
		end
	end
	return Angle( self.pitch, self.ang, self.roll )
end

function ENT:TakeDamage( amount, attacker )
	self.LastEnemy = attacker
end

function ENT:TraceEnemyEnt( entity, filter )
	local trace = {}
	trace.start = self:GetPos() + Vector( 0, 0, 2 )
	trace.endpos = entity:GetPos() + Vector( 0, 0, 1.5 )
	trace.filter = {self}
	trace.filter = table.Add( trace.filter, player.GetAll() )
	trace.filter = table.Add( filter or {} )
	local tr = util.TraceLine( trace )
	local insert = false
	local remove = false
	if (tr.Entity and tr.Entity == entity) || (table.HasValue( ents.FindInSphere( tr.HitPos, 3 ), entity ) and entity:IsUnit()) then
		if entity:GetPos():Distance( self:GetPos() ) >=self.minRange and entity:Visible( self ) then
			insert = true
		end
	elseif entity == self.LastEnemy then
		remove = true
	end
	return insert, remove
end

function ENT:FindRangedEntities()
	local range = ents.FindInSphere( self:GetPos() + self:GetDirection() * self.range/4, self.range )
	local filter = {}
	for _, ent in pairs( range ) do
		if ent.Overlord and ent.Overlord == self.Overlord then
			table.insert( filter, ent )
		end
	end
	return range, filter
end

function ENT:AttackSound( enemy )
	self:EmitSound( "sassilization/units/arrowfire0"..math.random( 1,2 )..".wav" )
end

function ENT:DoAttack( enemies, filter )
	local enemy = enemies[1]
	if self.LastEnemy then enemy = self.LastEnemy end
	if !self:TraceEnemyEnt( enemy, filter ) then return end
	self:LookAt( enemy:GetPos() )
	enemy:DealDamage( self.damage, self )
	local spos = self:GetPos() + Vector( 0, 0, 2 )
	local epos = enemy:GetPos() + Vector( 0, 0, 1.6 )
	local ang = (epos - spos):Normalize():Angle()
	ang.y = self.ang
	self:shootArrow( self:GetPos() + Vector( 0, 0, 2 ), enemy:GetPos() + Vector( 0, 0, 1.5 ), ang )
end