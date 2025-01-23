AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


function ENT:Setup()
	
	self:SetModel( UNITS[self.index].model )
	self.size = 10
	local vec1, vec2 = Vector( -5, -5, 0 ), Vector( 5, 5, 8 )
	self:PhysicsInitBox( vec1, vec2 )
	self:SetCollisionBounds( vec1, vec2 )
	self:SetSolid( SOLID_BBOX )
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

end

function ENT:GetHeading(pos,target,normal)
	if self.Target and !self.combatant then 
		self:LookAt( target )
		local ay = target.y - pos.y
		local ax = target.x - pos.x
		local rad = math.atan2( ay, ax )
		local dp = Vector( math.cos( rad ), math.sin( rad ), 0 ):DotProduct( normal ) * -1
		self.pitch = 360 - (( normal:Angle().p - 270 ) * dp * 2)
		local lift = dp * 200
		self.roll = normal:Angle().r
	end
	return Angle( self.pitch, self.ang, self.roll )
end

function ENT:TraceEnemyEnt( entity )
	local dir = (entity:GetPos() - self:GetPos()):Normalize()
	local trace = {}
	trace.start = self:GetPos() + self:OBBCenter()
	trace.endpos = entity:GetPos() + entity:OBBCenter()
	trace.filter = {self}
	trace.filter = table.Add( trace.filter, player.GetAll() )
	local tr = util.TraceLine( trace )
	local insert, remove
	if entity:IsUnit() and ((tr.Entity and tr.Entity == entity) || table.HasValue( ents.FindInSphere( tr.HitPos, 3 ), entity )) then
		if entity:GetPos():Distance( self:GetPos() ) >= self.minRange and (self:GetPos() + self:GetDirection() * self.range * 2):Distance( entity:GetPos() ) > self.range - 10 then
			insert = true
		end
	elseif entity == self.LastEnemy then
		remove = true
	end
	return insert, remove
end

function ENT:FindRangedEntities()
	return ents.FindInSphere( self:GetPos() + self:GetDirection() * self.range * 2, self.range )
end

function ENT:AttackSound( enemy )
	self:EmitSound( "sassilization/units/fireCrossbow.wav" )
end

function ENT:DoAttack( enemies )
	local enemy = enemies[1]
	if self.LastEnemy then
		enemy = self.LastEnemy
	end
	self:LookAt( enemy:GetPos() )
	local c = self:OBBCenter()
	local spos = self:GetPos() + Vector( c.x, c.y, c.z*2 )
	local epos = enemy:GetPos() + Vector( 0, 0, c.z*2 )
	local ang = (epos - spos):Angle()
	ang.y = self.ang
	self:shootArrow( self:GetPos() + Vector( c.x, c.y, c.z * 2 ), enemy:GetPos() + enemy:OBBCenter(), ang, math.random(2,4) )
end