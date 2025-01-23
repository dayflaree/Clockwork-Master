AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Setup()
	
	self:SetModel( UNITS[self.index].model )
	
	self:PhysicsInitSphere( self.size * 0.5 )
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
		delay = .724
	end
	if self:GetState() == ANIM_JUMP then
		self:SetAnim("jump")
		delay = 1.2
	end
	if self:GetState() == ANIM_ATTACK then
		self:SetAnim("swing")
		delay = 1.23
	end
	
	self.animtrans = CurTime() + delay
	
end

function ENT:GetHeading(pos)
	if !self.Normal then return Angle( 0, 0, 0 ) end
	if self.Target and !self.combatant then 
		self:LookAt( self.Target )
		local ay = self.Target.y - pos.y
		local ax = self.Target.x - pos.x
		local rad = math.atan2( ay, ax )
		local dp = Vector( math.cos( rad ), math.sin( rad ), 0 ):DotProduct( self.Normal ) * -1
		self.pitch = 360 - (( self.Normal:Angle().p - 270 ) * dp * 2)
		local lift = dp * 200
		self.roll = self.Normal:Angle().r
	end
	return Angle( self.pitch, self.ang, self.roll )
end

function ENT:TraceEnemyEnt( entity )
	local trace = {}
	trace.start = self:GetPos() + self:OBBCenter()
	trace.endpos = entity:GetPos() + entity:OBBCenter()
	trace.filter = {self}
	trace.filter = table.Add( trace.filter, player.GetAll() )
	local tr = util.TraceLine( trace )
	if tr.Entity and tr.Entity == entity then
		return true, false
	elseif !tr.HitWorld and table.HasValue( ents.FindInSphere( tr.HitPos, 3 ), entity ) and entity:IsUnit() and entity:GetClass() != "bldg_wall" then
		return true, false
	end
end

function ENT:FindRangedEntities()
	local range = ents.FindInSphere( self:GetPos() + self:GetDirection() * self.range * 0.25, self.range )
	local filter = {}
	for _, ent in pairs( range ) do
		if ent.Overlord and ent.Overlord == self.Overlord then
			table.insert( filter, ent )
		end
	end
	return range, filter
end

function ENT:AttackSound( enemy )
	if enemy:IsUnit() and enemy:IsFlesh() then
		self:EmitSound( "sassilization/units/flesh_hit0"..math.random( 1,3 )..".wav" )
	else
		self:EmitSound( "sassilization/units/building_hit0"..math.random( 1,3 )..".wav" )
	end
end

function ENT:DoAttack( enemies )
	self:LookAt( enemies[1]:GetPos() )
	for _, enemy in pairs( enemies ) do
		enemy:DealDamage( self.damage, self )
	end
end