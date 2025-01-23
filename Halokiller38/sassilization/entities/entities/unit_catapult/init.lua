AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


function ENT:Setup()
	
	self:SetModel( UNITS[self.index].model )
	local vec1, vec2 = Vector( -6, -6, 0 ), Vector( 6, 6, 8 )
	self.size = 12
	self:PhysicsInitBox( vec1, vec2 )
	self:SetCollisionBounds( vec1, vec2 )
	self:SetSolid( SOLID_BBOX )
	self:SetMoveCollide( MOVECOLLIDE_FLY_SLIDE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:DrawShadow( false )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
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
	local trace = {}
	trace.start = self:GetPos() + Vector( 0, 0, 48 )
	trace.endpos = entity:GetPos() + Vector( 0, 0, 1.5 )
	trace.filter = {self}
	trace.filter = table.Add( trace.filter, player.GetAll() )
	local tr = util.TraceLine( trace )
	local insert = true
	local remove = false
	if ValidEntity(tr.Entity) and (tr.Entity == entity || table.HasValue( ents.FindInSphere( tr.HitPos, 3 ), entity )) then
		if entity:GetPos():Distance( self:GetPos() ) < self.minRange then
			self.tooclose = true
			insert = false
		elseif (self:GetPos() + self:GetDirection() * self.range * 2):Distance( entity:GetPos() ) < self.range - 10 then
			insert = false
		end
		if !insert and entity == self.LastEnemy then
			remove = true
		end
	end
	return insert, remove
end

function ENT:FindRangedEntities()
	return ents.FindInSphere( self:GetPos() + self:GetDirection() * self.range * 2, self.range )
end

function ENT:AttackSound( enemy )
	if self.tooclose then return end
	self:EmitSound( "sassilization/units/ballista_fire0"..math.random( 1,2 )..".wav" )
end

function ENT:DoAttack( enemies )
	if self.tooclose then return end
	self:LookAt( enemies[1]:GetPos() )
	local pos1 = enemies[1]:GetPos()
	local pos2 = self:GetPos()
	local power = Vector(pos1.x,pos1.y,0):Distance(Vector(pos2.x,pos2.y,0))*1.15
	local dir = (enemies[1]:GetPos() - self:GetPos()):Normalize()
	local upness = (enemies[1]:GetPos().z - self:GetPos().z)/64+1.2
	if upness < 1.2 then upness = 1.2 end
	self:ShootRock( Vector( 0, 0, 12 ), Vector( dir.x, dir.y, upness ), power )
	--self:SetAnim("launch")
end