AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


function ENT:Setup()
	
	self:SetModel( UNITS[self.index].model )
	self:SetColor( 255, 255, 255, 255 )
	self.size = 12
	local vec1, vec2 = Vector( -8, -8, 0 ), Vector( 8, 8, 12 )
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

function ENT:Animate()
end

function ENT:StartTouch(ent)
	if ent:IsUnit() and ent.index < 3 then
		ent:Disband("death")
	end
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

function ENT:DoDeath()
	self:Survivors( 12 )
	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetScale( 14 )
		effectdata:SetMagnitude( GIB_WOOD )
	util.Effect( "gib_structure", effectdata )
	self:EmitSound( "sassilization/units/buildingbreak0"..math.random(1,2)..".wav" )
end

function ENT:Survivors( amount )
	if !(self.Overlord and self.Overlord:IsValid()) then return end
	local survivors = amount/5
	for j=1, 5 do
		for i=1, 5 do
			if self.Overlord:GetNWInt("_soldiers") + 1 >= unit_limit then return end
			local px = i*8 - (survivors*0.5)*8 - 8
			local py = math.Rand( -16, 16 )
			local trace = {}
			trace.start = self.Entity:GetPos() + Vector( px, py, 20 )
			trace.endpos = self.Entity:GetPos() + Vector( px, py, -20 )
			trace.mask = (SOLID)
 			local tr = util.TraceLine( trace )
			local ent = ents.Create( "unit_swordsman" )
			local ang = tr.HitNormal:Angle()
			ang.p = ang.p + 90
			ent:SetAngles( ang )
			ent.index = 1
			ent:Spawn()
			ent:Activate()
			ent:SetSpawner(self.Overlord)
			local min = ent:OBBMins()
			ent:SetPos( tr.HitPos - tr.HitNormal * ( min.z - 1 ) + tr.HitNormal * j * 6 )
		end
	end
end

function ENT:TraceEnemyEnt( entity )
	return nil, nil
end

function ENT:FindRangedEntities()
	return {}
end

function ENT:AttackSound( enemy )
	return nil
end

function ENT:DoAttack( enemies )
end