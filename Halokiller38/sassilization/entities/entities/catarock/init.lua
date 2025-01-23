AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )



util.PrecacheModel( "models/jaanus/catarock.mdl" );

resource.AddFile("models/jaanus/catarock.mdl")
resource.AddFile("models/jaanus/catarock.vvd")
resource.AddFile("models/jaanus/catarock.sw.vtx")
resource.AddFile("models/jaanus/catarock.dx90.vtx")
resource.AddFile("models/jaanus/catarock.dx80.vtx")
resource.AddFile("models/jaanus/catarock.phy")

function ENT:Initialize()
	
	//the rock
	self:SetModel( "models/jaanus/catarock.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetColor( 255, 255, 255, 255 )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion( true )
		phys:Wake()
		phys:ApplyForceCenter( self.LaunchDir * self.power * 1.32 )
	end
	
	timer.Simple( 8, self.Raze, self )
	
	self.HitUnits = {}
	self.CanHit = true
	
end

function ENT:StartTouch( ent )
	if !self.CanHit then return end
	if !ValidEntity( ent ) then return end
	if !IsAttackable( ent ) then return end
	if ent:IsDead() then return end
	if IsAttackable( ent ) and ent:GetOverlord() ~= self:GetOverlord() then
		if !self.HitUnits[ent] then
			self.HitUnits[ent] = true
			ent:DealDamage( math.Rand( 6, 12 ), self )
			if ent:GetClass() ~= "unit_*" then
				ent:DealDamage( math.Rand( 20, 30 ), self )
				self:EmitSound( "sassilization/units/building_hit0"..math.random( 1,3 )..".wav" )
			end
			function self:StartTouch( ent ) return end
			function self:PhysicsCollide( data, phys ) return end
		end
	end
end

function ENT:PhysicsCollide( data, phys )
	if !self.CanHit then return end
	if self.Hit then return end
	local ent = data.HitEntity
	if data.Speed > 80 and ValidEntity( ent ) then
		self.Hit = true
		if IsAttackable( ent ) and !ent:IsDead() and ent:GetOverlord() ~= self:GetOverlord() then
			ent:DealDamage( math.Rand( 20, 30 ), self )
			self:EmitSound( "sassilization/units/building_hit0"..math.random( 1,3 )..".wav" )
			self.StartTouch = function()end
			self.PhysicsCollide = function()end
		end
	end
end

function ENT:SetSpawner(ply)
	self.SpawnedBy = ply
	self.Overlord = ply
end

function ENT:GetOverlord()
	return self.Overlord
end

function ENT:Raze()
	if self.Dead then return end
	self.Dead = true
	if self.Entity and self.Entity:IsValid() then
		local ent = self.Entity
		local function RemoveEntity( ent )
 				ent:Remove()
 		end
 		timer.Simple( 1, RemoveEntity, ent )
	 	ent:SetNotSolid( true )
	 	ent:SetNoDraw( true )
	end
end