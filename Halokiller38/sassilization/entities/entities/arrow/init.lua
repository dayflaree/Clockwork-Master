AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )



util.PrecacheModel( "models/jaanus/arrow.mdl" );
util.PrecacheModel( "models/jaanus/arrow_small.mdl" );

resource.AddFile("materials/jaanus/arrow.vtf")
resource.AddFile("materials/jaanus/arrow.vmt")
resource.AddFile("models/jaanus/arrow.mdl")
resource.AddFile("models/jaanus/arrow_small.mdl")


function ENT:Initialize()
	
	self.Overlord = self.Overlord or nil
	
	self.Damage = self.Damage or 3
	self.Dead = false
	
	//the arrow
	if self.Bomb then
		self:SetModel( "models/jaanus/arrow.mdl" )
	else
		self:SetModel( "models/jaanus/arrow_small.mdl" )
	end
	
	self:PhysicsInitSphere( 1 )
	self:SetCollisionBounds( Vector(-2,-2,-0.1), Vector(2,2,0.1) )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetMoveCollide( MOVECOLLIDE_FLY_SLIDE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetColor( 255, 255, 255, 255 )
	self:SetTrigger( true )
	
	self.trail = util.SpriteTrail(	self,
					0,
					Color( 180, 180, 180, 80 ),
					false,
					1,
					0.01,
					0.5,
					0.5,
					"trails/laser.vmt"
				)
	
	timer.Simple( 2, self.Raze, self )
	
	if self.Gravitated then return end
	
	self:SetAngles( self.AngStart )
	self.DirAngle = (self.PosTarget - self.PosStart):Angle()
	self:SetPos( self.PosStart + (Vector(self.DirAngle:Forward().x,self.DirAngle:Forward().y,0) * 8) )
	
	local power = self.PosStart:Distance( self.PosTarget ) * 1.5
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetMass( 1 )
		phys:EnableMotion(true)
		phys:EnableGravity( false )
		phys:SetVelocity( self.DirAngle:Forward() * power * 2 )
	end
	
end

function ENT:GetPredictedTarget()

	if !self.PredictedTarget then
		
		local trace = {}
		trace.start = self.PosStart + Vector( 0, 0, 6 )
		trace.endpos = self.PosTarget
		trace.filter = {self, self.Shooter}
		trace.filter = table.Add(trace.filter,ents.FindByClass("arrow"))
		trace.filter = table.Add(trace.filter,player.GetAll())
		
		local tr = util.TraceLine( trace )
		
		if tr.Hit and tr.HitPos:Distance( self.PosStart + Vector( 0, 0, 6 ) ) > 6 then
			self.Predict = tr.HitPos
			if ValidEntity(tr.Entity) then
				self.PredictedTarget = tr.Entity
				self.Predict = {}
				self.Predict.ang = tr.HitPos - tr.Entity:GetPos():Normalize()
				self.Predict.dis = tr.Entity:GetPos() - tr.HitPos
			end
			if self.Bomb then
				local ents = ents.FindInSphere( tr.HitPos, 6 )
				if #ents > 0 then
					for _, ent in pairs( ents ) do
						if ent and ent ~= self and IsAttackable( ent ) and ent:GetOverlord() then
							if ent:GetOverlord() ~= self:GetOverlord() and !table.HasValue( alliances[self:GetOverlord()], ent:GetOverlord() ) then
								self.PredictedTarget = ent
								break
							end
						end
					end
				end
			end
		end
		
	end
	
end

function ENT:Think()
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		if phys:GetVelocity().z > 0 then
			phys:EnableMotion( true )
			phys:EnableGravity( true )
		end
	end
	
end

function ENT:StartTouch( ent )
	
	self:DoTouch( ent, self:GetPhysicsObject() )
	
end

function ENT:DoTouch( ent, phys )
	
	if ent and ent:IsPlayer() then return end
	
	if (phys and phys:IsValid()) then
		
		phys:EnableGravity(true)
		
		self.StartTouch = function()end
		self.PhysicsCollide = function( self, data, phys )
			if data.HitEntity:IsWorld() then
				phys:EnableMotion( false )
				self.PhysicsCollide = function()end
			end
		end
		
		if self.Bomb then
			local ents = ents.FindInSphere( ent:GetPos(), 12 )
			for _, ent in pairs( ents ) do
				if ent and IsAttackable( ent ) and ent:IsUnit() and ent:IsFlesh() and !(ent:GetOverlord() == self.Overlord and table.HasValue( alliances[self.Overlord], ent:GetOverlord() )) then
					ent:DealDamage( self.Damage*3, self )
				end
			end
		end
		
		if self.Predict then
			if self.PredictedTarget and self.PredictedTarget:IsValid() and !self.PredictedTarget:IsDead() and !self.Bomb then
				self:SetPos( self.PredictedTarget:GetPos() + (self.Predict.ang * self.Predict.dis) )
			elseif self.PredictedTarget and self.PredictedTarget:IsValid() and self.Predict.ang then
				self:SetPos( self.PredictedTarget:GetPos() + (self.Predict.ang * self.Predict.dis) )
			elseif !self.Predict.ang then
				self:SetPos( self.Predict )
				phys:EnableMotion(false)
			else
				phys:EnableMotion(false)
			end
			if self.PredictedTarget and self.PredictedTarget.DealDamage and self.Bomb then
				if self.PredictedTarget:IsUnit() and !self:IsFlesh() then
					self.PredictedTarget:DealDamage( self.Damage*0.5, self )
					return
				end
				self.PredictedTarget:DealDamage( self.Damage, self )
				if self.PredictedTarget:IsUnit() and self:IsFlesh() then
					self.PredictedTarget:DealDamage( self.Damage*2, self )
				end
			end
		end
		
	end
	
end

function ENT:PhysicsCollide( data, phys )
	local ent = data.HitEntity
	if ent == self:GetOwner() then return end
	if ValidEntity( ent ) and IsAttackable(ent) and ent:IsReady() then
		self:DoTouch( ent, phys )
		return
	end
	if ent:IsWorld() and data.HitNormal:Dot(Vector(0,0,1)) < 0.1 then
		phys:EnableMotion( false )
		self.StartTouch = function()end
		self.PhysicsCollide = function()end
	end
end

function ENT:SetSpawner(ply)
	self:SetColor( ply:GetColor() )
	self.Overlord = ply
end

function ENT:Raze()
	if self.Dead then return end
	self.Dead = true
	if ValidEntity( self ) then
		local function RemoveEntity( ent )
 				ent:Remove()
 		end
 		timer.Simple( 1, RemoveEntity, self )
	 	self:SetNotSolid( true )
 		self:SetMoveType( MOVETYPE_NONE )
	 	self:SetNoDraw( true )
	end
end