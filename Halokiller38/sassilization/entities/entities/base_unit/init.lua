AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.PrecacheModel( "models/jaanus/peasant.mdl" );
util.PrecacheModel( "models/jaanus/swordsman.mdl" );
util.PrecacheModel( "models/jaanus/crossbowman.mdl" );
util.PrecacheModel( "models/jaanus/catapult.mdl" );
util.PrecacheModel( "models/jaanus/catarock.mdl" );
util.PrecacheModel( "models/jaanus/galleon_intact.mdl" );
util.PrecacheModel( "models/jaanus/galleon_halfbroken.mdl" );
util.PrecacheModel( "models/jaanus/galleon_immobile.mdl" );
util.PrecacheModel( "models/jaanus/galleon_scuttled_front.mdl" );
util.PrecacheModel( "models/jaanus/galleon_scuttled_rear.mdl" );
util.PrecacheModel( "models/jaanus/galleon_frontmast.mdl" );
util.PrecacheModel( "models/jaanus/galleon_rearmast.mdl" );
util.PrecacheModel( "models/jaanus/scallywag_unbroken.mdl" );
util.PrecacheModel( "models/jaanus/scallywag_broken.mdl" );

AccessorFunc( ENT, "m_iState", "State", FORCE_NUMBER )

local META = FindMetaTable("Entity")
if !META then return end

function META:IsUnit(ent)
	return string.find( self:GetClass(), "unit_" )
end

function META:IsFlesh()
	return self.fleshy
end

function META:GetOverlord()
	if !self.Overlord then return nil end
	if ValidEntity(self.Overlord) and self.Overlord:IsPlayer() then
		return self.Overlord
	end
end

META = nil

function ENT:GetDirection()
	return Angle( 0, self.ang, 0 ):Forward()
end

function ENT:UpdateColor()
	local r,g,b,a = self:GetColor()
	self.oldcol = Color( r, g, b, a )
end

function ENT:RestoreColor()
	if !self.oldcol then return end
	self:SetColor( self.oldcol.r,self.oldcol.g,self.oldcol.b,self.oldcol.a )
end

function ENT:AnimState( state )
	if self:GetState() ~= state then
		self:SetState( state )
		self.animtrans = 0
	end
end

function ENT:Initialize()
	
	self.AutomaticFrameAdvance = true
	
	--Identity
	self.index = self.index or 1
	
	--Characteristics
	local unit = UNITS[self.index]
	self.name = unit.name
	self.supply = unit.supply
	self.maxhealth = unit.health
	self.health = self.maxhealth
	self.damage = unit.damage
	self.minRange = unit.minRange
	self.range = unit.range
	self.delay = unit.delay
	self.turning = unit.turning
	self.speed = unit.speed
	self.size = unit.size
	self.clamp = 0
	
	self:Setup(self:GetPos())
	
	--Variables
	self.LastNormal = CurTime() + 3
	self.Last = self:GetPos()
	self.Distance = 0 			//The distance to the unit's target
	self.Clock = true 			//The unit will attack or look for something to attack when true
	local ang = self:GetAngles()
	self.ang = ang.y
	self.pitch = ang.p
	self.roll = ang.r
	self.lastMove = CurTime() + 4
	self.Grounded = true
	
	blockCheck( self )
	
end

function ENT:SetSpawner(ply)
	
	if !(ValidEntity( ply ) and ply:IsPlayer()) then return end
	
	self.SpawnerID = ply:UserID()
	
	ply:SetNWInt("_soldiers", ply:GetNWInt("_soldiers") + 1)
	ply:SetNWInt("_supplied", ply:GetNWInt("_supplied") + self.supply )
	
	self.Overlord = ply
	self:SetOwner( ply )
	
	self:UpdateColor()
	local rand = math.random(#UNITSPAWNSOUNDS)
	ply:SendLua("playsound('"..UNITSPAWNSOUNDS[rand][1].."', "..UNITSPAWNSOUNDS[rand][2]..")")
	
	local r,g,b,a = ply:GetColor()
	umsg.Start( "UUC" )
		umsg.Short( self:EntIndex() )
		umsg.Short( r )
		umsg.Short( g )
		umsg.Short( b )
	umsg.End()
	
end

function ENT:PerformParalyze( pos, phys)
	
	if !self.Paralyzed then return end
	if self.Paralyzed == 1 then
		phys:EnableMotion(false)
		phys:Sleep()
		return
	elseif self.Paralyzed == 2 then
		self.Paralyzed = false
		self:SetNWBool( "paralyzed", false )
		phys:EnableMotion(true)
		phys:Wake()
	end
	
end

function ENT:PerformGravitate( pos, phys )
	
	if !self.Gravitated then return end
	if self.Gravitated == 1 then
		phys:EnableGravity(false)
		phys:EnableMotion(true)
		phys:SetVelocity(Vector(0,0,50))
		return
	elseif self.Gravitated == 2 then
		self.Gravitated = 3
		self:SetNWBool( "gravitated", false )
		phys:EnableGravity(true)
		phys:EnableMotion(true)
		phys:Wake()
	elseif self.Gravitated == 4 then
		self.Gravitated = false
		self:SetNWBool( "gravitated", false )
		phys:EnableGravity(true)
		phys:EnableMotion(true)
		phys:Wake()
	end
	
end

function ENT:PerformDecimate( pos, phys )
	
	if self.OnFire and !self.Decimated then
		self.OnFire = false
	elseif !self.OnFire and self.Decimated then
		self.OnFire = true
		self.Target = Vector( pos.x + math.Rand( -1, 1 ), pos.y + math.Rand( -1, 1 ), 0 )
	elseif self.OnFire and self.Decimated then
		self:DealDamage( 1.5, self )
		self.Target = Vector( pos.x + math.Rand( -1, 1 ), pos.y + math.Rand( -1, 1 ), 0 )
	end
	
end

function ENT:DelayThink( time )
	
	self.nextThink = time
	return true
	
end

function ENT:Animate() end

function ENT:Think()
	
	if self:IsDead() then return end
	
	self:Animate()
	
	self:NextThink( CurTime() )
	
	local phys = self:GetPhysicsObject()
	
	self.nextThink = self.nextThink or CurTime() + 1
	if self.nextThink > CurTime() and phys:IsAsleep() then return true end
	self.nextThink = CurTime() + 1
	
	local pos = self:GetPos()
	
	if !(ValidEntity(self.Overlord) and self.Overlord:IsPlayer()) then
		return self:Disband( "cleanup" )
	elseif !ValidEntity( self:GetOwner() ) then
		return self:Disband( "cleanup" )
	elseif !self.Overlord then
		return self:Disband( "cleanup" )
	elseif pos.z < -9001 then
		return self:Disband( "cleanup" )
	end

	if self:WaterLevel() > 0 then
		if !self.waterbase then
			self:DealDamage(2, self)
			self:DelayThink( CurTime() + 2 )
			return true
		end
	end
	
	self:PerformParalyze( pos, phys )
	self:PerformGravitate( pos, phys )
	self:PerformDecimate( pos, phys )
	
	if self.Gravitated || self.Paralyzed then
		self:DelayThink( CurTime() + 2 )
		return true
	end
	
	//////////////
	//NAVIGATION//
	//////////////
	
	if ValidEntity( self.TargetEnemy ) then
		self.Target = self.TargetEnemy:GetPos()
		if self.TargetEnemy:IsDead() then
			self.TargetEnemy = false
		end
	end
	
	local trace = {}
	trace.start = pos + Vector( 0, 0, 5 )
	trace.endpos = trace.start - Vector( 0, 0, 18 )
	trace.mask = MASK_SOLID_BRUSHONLY
	local tr = util.TraceLine( trace )
	if tr.HitWorld then
		if self.Target then self.Grounded = CurTime() + .5
		else self.Grounded = true end
		self.falling = nil
	else
		self.Grounded = false
	end
	
	if !self:IsGrounded() and !self.flies then
		if phys:IsAsleep() then
			phys:Wake()
		end
	elseif !self.combatant and (self.Ordered || self.flies) then
		self:ExecuteUniqueMovement(phys)
		if phys:IsAsleep() then
			phys:Wake()
		end
	elseif !self.flying then
		self:AnimState( ANIM_IDLE )
		phys:SetVelocity( Vector( 0, 0, 0 ) )
		phys:SetVelocityInstantaneous( Vector( 0, 0, 0 ) )
		phys:AddAngleVelocity( phys:GetAngleVelocity()*-1 )
		phys:SetAngle( Angle( 0, 0, 0 ) )
		phys:Sleep()
	end
	
	//////////
	//COMBAT//
	//////////
	
	if self:GetClass() != "unit_horsie" then
		self:PerformCombat()
	end
	
	if CurTime() > self.lastMove then
		self:DelayThink( CurTime() + 2 )
		return true
	end
	
end

function ENT:IsGrounded()
	if !self.Grounded then return false end
	if self.Grounded == true then return true end
	if tonumber(self.Grounded or 0) > CurTime() then return true end
	return false
end

function ENT:PhysicsSimulate(Phys, deltatime)
	
	if self.Blasted || self.Gravitated || self:WaterLevel() > 0 then
		
		self:AnimState( ANIM_JUMP )
		return
		
	end
	
	if (self.Target and (!self.combatant or self.Ignore)) then
		
		self:AnimState( ANIM_RUN )
		
		if CurTime() > self.lastMove - 2 then
			self.lastMove = CurTime() + 4
		end
		
	elseif self.Decimated then
		
		self.Target = self:GetPos() + Vector( math.Rand( -5, 5 ), math.Rand( -5, 5 ), 0 )
		
	else
		
		if !self.combatant then
			self:AnimState( ANIM_IDLE )
		end
		
		return
		
	end
	
	local pos = self:GetPos()
	local Position = self.Target or pos
	
	if IsEntity(Position) then
		if !Position:IsValid() then return end
		Position = self.Target:GetPos()
	end
	
	self.Distance = pos:Distance( Vector( Position.x, Position.y, pos.z ) )
	
	if self.Distance <= 8 and !self.Decimated and !IsEntity( self.Target ) then
		self.Target = false
		self.Ordered = false
	end
	
	local Ang = (Position - pos):Normalize()
	Ang = Vector( Ang.x, Ang.y, 0 ):Angle()
	self.ang = Ang.y
	
	self:SetAngles( Angle( 0, 0, 0 ) )
	
	local trace = {}
	trace.start = pos + Vector( 0, 0, 5 )
	trace.endpos = trace.start + self:GetDirection() * 64 + Vector( 0, 0, 64 )
	trace.mask = MASK_SOLID_BRUSHONLY
	local tr = util.TraceLine( trace )
	trace.endpos = tr.HitPos + tr.HitNormal * 2 + Vector( 0, 0, -100 )
	tr = util.TraceLine( trace )
	Position = tr.HitPos + tr.HitNormal
	trace.endpos = trace.start - Vector( 0, 0, 18 )
	tr = util.TraceLine( trace )
	
	if tr.HitWorld then
		
		if self.Target then self.Grounded = CurTime() + .5
		else self.Grounded = true return end
		self.falling = nil
		
	else
		
		self.Grounded = false
		return Vector( 0, 0, 0 ), Vector( 0, 0, -500 ), SIM_LOCAL_ACCELERATION
		
	end
	
	if self.Ordered then
		self.ShadowParams = {}
		self.ShadowParams.secondstoarrive = 0.05
		self.ShadowParams.pos = Position
		self.ShadowParams.angle = Angle( 0, 0, 0 )
		self.ShadowParams.maxangular = self.turning * 25
		self.ShadowParams.maxangulardamp = 10000
		self.ShadowParams.maxspeed = self.speed * 12 * (1-FrameTime())
		self.ShadowParams.maxspeeddamp = 10000
		self.ShadowParams.dampfactor = 0.98
		self.ShadowParams.teleportdistance = 0
		self.ShadowParams.deltatime = deltatime
		Phys:ComputeShadowControl(self.ShadowParams)
	else
		Phys:SetVelocity( Vector( 0, 0, 0 ) )
		Phys:SetVelocityInstantaneous( Vector( 0, 0, 0 ) )
		Phys:AddAngleVelocity( Phys:GetAngleVelocity()*-1 )
	end
	
end

function ENT:CanAttack( time )
	if self.Decimated then return false end
	if self.Paralyzed then return false end
	if self.Gravitated then return false end
	if time < self.lastAttack then return false end
	return true
end

function ENT:PerformCombat()
	
	local time = CurTime()
	
	self.lastAttack = self.lastAttack or 0
	self.lastClock = self.lastClock or time
	if !self:CanAttack(time) then return end
	
	if time >= self.lastClock then
		
		self.lastClock = time + self.delay * 0.25
		
		local entities, filter = self:FindRangedEntities()
		local enemies = {}
		
		for _, entity in pairs( entities ) do
			if (entity ~= self and IsAttackable( entity ) and entity:GetOverlord() and entity:GetOverlord() ~= self:GetOverlord() and !entity:IsDead()) then
				if !table.HasValue( alliances[self:GetOverlord()], entity:GetOverlord() ) then
					local insert, remove = false, true
					if entity:GetClass() == "unit_horsie" and entity.Ordered then
						insert, remove = true, nil
					elseif self.TargetEnemy then
						if self.TargetEnemy == entity then
							insert, remove = true, nil
						end
					else
						insert, remove = self:TraceEnemyEnt( entity, filter )
					end
					if insert then
						table.insert( enemies, entity )
					elseif remove then
						self.LastEnemy = nil
					end
				end
			end
		end
		if #enemies == 0 then
			if self.combatant then
				gmod.BroadcastLua( "UNITS.targets["..self:EntIndex().."]=nil" )
				umsg.Start( "UUT" )
					umsg.Short( self:EntIndex() )
					umsg.Short( 0 )
				umsg.End()
			end
			self.combatant = false
			self.LastEnemy = nil
			return
		else
			self.tooclose = false
			self:AnimState( ANIM_ATTACK )
			self.combatant = true
			self.BlockClock = false
			self:AttackSound( enemies[1] )
			self.LastEnemy = self.LastEnemy or enemies[1]
			gmod.BroadcastLua( "UNITS.targets["..self:EntIndex().."]="..enemies[1]:EntIndex() )
			umsg.Start( "UUT" )
				umsg.Short( self:EntIndex() )
				umsg.Short( enemies[1]:EntIndex() )
			umsg.End()
		end
		
		if !(ValidEntity(self.LastEnemy) and !self.LastEnemy:IsDead()) then
			self.LastEnemy = nil
		end
		
		self.lastAttack = time + self.delay
		self.lastMove = time + 4
		self:DoAttack( enemies )
		
	end
	
end

function ENT:DealDamage( amount, attacker )
	if !attacker or !attacker:IsValid() or attacker:IsDead() then return end
	if !self then return end
	
	//Tell the minimap we're under attack
	self.lastAttacked = 1
	
	if self.health - amount > 0 then
		self.health = self.health - amount
		umsg.Start( "UUH" )
			umsg.Short( self:EntIndex() )
			umsg.Short( self.health )
		umsg.End()
		if attacker:GetClass() == "catarock" || attacker:GetClass() == "arrow" then return end
		if !self.Target and attacker != self and self:GetClass() != "unit_horsie" then
			self.Ordered = true
			self.TargetEnemy = attacker
			self.Target = attacker:GetPos()
			self.Distance = 100
			self.BlockClock = false
			for _, friendly in pairs( self:GetNearbyAllies( 26 ) ) do
				if !friendly.Ordered and friendly:GetClass() != "unit_horsie" then
					friendly.Ordered = true
					friendly.TargetEnemy = attacker
					friendly.Target = attacker:GetPos()
					friendly.Distance = 100
					friendly.BlockClock = false
				end
			end
		end
	else
		if attacker == self then
			self:Disband( "death" )
			return
		else
			attacker.TargetEnemy = false
			gmod.BroadcastLua( "UNITS.targets["..attacker:EntIndex().."]=nil" )
			umsg.Start( "UUT" )
				umsg.Short( attacker:EntIndex() )
				umsg.Short( 0 )
			umsg.End()
		end
		self:Disband( "death", attacker:GetOverlord() )
		if attacker:GetClass() == "arrow" then
			attacker.Predict = false
			attacker:GetPhysicsObject():EnableGravity( true )
			attacker:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			local phys = attacker:GetPhysicsObject()
			phys:EnableMotion(true)
			phys:Wake()
		end
	end
end

function ENT:TakeDamage( amount, attacker ) return end
function ENT:OnTakeDamage( dmginfo ) dmginfo:SetDamage(0) self:SetHealth(9999) return false end

function ENT:GetNearbyAllies( radius )
	local ents = ents.FindInSphere( self:GetPos(), radius )
	local allies = {}
	for _, ent in pairs( ents ) do
		if ValidEntity( ent ) and ent:IsUnit() and ent ~= self and ent:IsReady() then
			if ent:GetOverlord() == self:GetOverlord() or table.HasValue( alliances[self:GetOverlord()], ent:GetOverlord() ) then
				table.insert( allies, ent )
			end
		end
	end
	return allies
end

function blockCheck( self )
	if !ValidEntity(self) then return end
	if self.Dead then return end
	local pos = self:GetPos()
	timer.Simple( 3, blockCheck, self )
	if !self.Ordered or self.combatant then return end
	if self.Last:Distance(pos) < 15 and self.BlockClock then
		self.Ordered = false
		self.Target = false
		self.Distance = 0
	else
		self.Last = pos
	end
	self.BlockClock = true
end

function ENT:PhysicsCollide( data, phys )
	local Ent = data.HitEntity
	if ValidEntity( Ent ) then
		if Ent == self.TargetEnemy then
			self.Ordered = false
		end
		if Ent:IsUnit() and Ent.Target == self.Target and Ent.Distance <= 20 and !Ent:IsCombatant() then
			self.Ordered = false
			self.Distance = 0
			self.Target = false
			self.BlockClock = false
		end
		if self.falling and Ent:IsStructure() then
			return self:Disband()
		end
		if Ent:GetClass() == "bldg_shrine" and Ent:IsReady() and (Ent:GetOverlord() == self.Overlord || table.HasValue( alliances[self.Overlord], Ent:GetOverlord())) then
			self.shrine = Ent
			self:Disband( "sacrifice" )
			local spirit = 1
			if (self.index == 0 || self.index == 3 || self.index == 4) then
				spirit = 2
			end
			Ent:GetOverlord():SetNWInt("_spirits", Ent:GetOverlord():GetNWInt( "_spirits" ) + spirit)
		end
	end
	if self.Gravitated == 3 then
		if Ent and Ent:GetClass() == "worldspawn" then
			self:DealDamage(math.random(8,17), self)
			self.Gravitated = nil
		end
	end
end

function ENT:Select( ply )
	if ply and ply:IsPlayer() then
		if !self:IsDead() and !self:IsSelected() then
			ply.Units[self:EntIndex()] = self
			ply.SelectedUnits = table.Count( ply.Units )
			umsg.Start( "SU", ply )
				umsg.Short( self:EntIndex() )
			umsg.End()
		end
	end
end

function ENT:Deselect( ply )
	if ply and ply:IsPlayer() and ply == self.Overlord then
		ply.Units[self:EntIndex()] = nil
		ply.SelectedUnits = table.Count( ply.Units )
		umsg.Start( "DSU", ply )
			umsg.Short( self:EntIndex() )
		umsg.End()
		if self:IsDead() then
			self.WasSelected = true
		end
	end
end

function ENT:LookAt( target )
	if !target then return end
	if IsEntity(target) then
		if !target:IsValid() then return end
		target = target:GetPos()
	end
	local p = self:GetPos()
	local q = target
	local dy = q.y - p.y
	local dx = q.x - p.x
	local rad = math.atan2(dy, dx)
	local ang = math.Round(rad/3.14159*180)
	self.ang = math.ApproachAngle( self.ang, ang, self.turning )
end

function ENT:IsCombatant()
	return self.combatant
end

function ENT:IsSelected()
	if !(ValidEntity( self.Overlord )) then return false end
	return self.Overlord.Units[ self:EntIndex() ]
end

function ENT:shootArrow( spos, epos, ang, dmg, enemy )
	local arr = ents.Create( "arrow" )
	arr:SetPos( spos )
	arr.PosStart = spos
	arr.PosTarget = epos
	arr.AngStart = ang + Angle( 90, 0, 0 )
	arr.Shooter = self
	if dmg then
		arr.Damage = dmg
		arr.Bomb = true
		arr.PredictedTarget = enemy
	end
	arr.Overlord = self:GetOverlord()
	arr:SetOwner( self )
	arr:Spawn()
	arr:Activate()
	arr:GetPredictedTarget()
	arr:SetSpawner( self:GetOverlord() )
end

function ENT:ShootRock( off, dir, pow )
	local rock = ents.Create( "catarock" )
	rock:SetPos( self:GetPos() + off )
	rock.LaunchDir = dir
	rock.power = pow
	rock:SetOwner( self )
	rock:Spawn()
	rock:Activate()
	rock:SetSpawner( self:GetOverlord() )
end

function ENT:OnRemove()
	if ValidEntity( self.Overlord ) and self.Overlord:IsPlayer() then
		if self:IsSelected() then self:Deselect( self.Overlord ) end
		self.Overlord:SetNWInt( "_supplied", self.Overlord:GetNWInt( "_supplied" ) - self.supply )
		self.Overlord:SetNWInt("_soldiers", self.Overlord:GetNWInt("_soldiers") - 1)
		self.Overlord = nil
	end
end

function ENT:Disband( info, inflictor )
	info = info or "death"
	if self.Dead then
		return
	end
	self.Dead = true
	self:SetNWBool("dead", true)
	if ValidEntity( self.Overlord ) and self.Overlord:IsPlayer() then
		if self:IsSelected() then self:Deselect( self.Overlord ) end
		self.Overlord:SetNWInt( "_supplied", self.Overlord:GetNWInt( "_supplied" ) - self.supply )
		self.Overlord:SetNWInt("_soldiers", self.Overlord:GetNWInt("_soldiers") - 1)
	end
	if inflictor and inflictor:IsPlayer() then
		inflictor:SetNWInt("_gold", inflictor:GetNWInt("_gold")+2)
		inflictor.killcashbonus = inflictor.killcashbonus + 1
	end
	if ValidEntity(self) then
		self:Extinguish()
		local function RemoveEntity( self )
 			if ValidEntity( self ) then
				RemovingEntCount = RemovingEntCount - 1
				self.Overlord = nil
 				self:Remove()
 			end
 		end
		RemovingEntCount = RemovingEntCount + 1
 		timer.Simple( RemovingEntCount * .01 * (info == "refund" and 150 or 1), RemoveEntity, self )
	 	self:SetNotSolid( true )
 		self:SetMoveType( MOVETYPE_NONE )
	 	self:SetNoDraw( true )
		if info == "cleanup" then return end
		if info == "sacrifice" then
			self.shrine = self.shrine or self:GetPos()
			self:SetPos( self.shrine:GetPos() + Vector( math.Rand( -.2, .2 ), math.Rand( -.2, .2 ), 5 ) )
			local effectdata = EffectData()
				effectdata:SetEntity( self )
				effectdata:SetOrigin( self.shrine:GetPos() + Vector( math.Rand( -.2, .2 ), math.Rand( -.2, .2 ), 5 ) )
			util.Effect( "spirit", effectdata, true, true )
			self.Overlord:SendLua("playsound('sassilization/units/sacrificed.wav', -1)")
		end
		if info == "death" then
			self:DoDeath()
		end
	end
end

function ENT:DoDeath()
	local entity = self
	local effectdata = EffectData()
		effectdata:SetEntity( self )
		effectdata:SetOrigin( self:GetPos())
	util.Effect( "gib_explosion", effectdata )
	if math.random(4) > 2 then
		local trace = {}
		trace.start = entity:GetPos()
		trace.endpos = trace.start + (Vector(0,0,-1) * 100)
		local tr = util.TraceLine(trace)
		local pos1 = tr.HitPos + tr.HitNormal
		local pos2 = tr.HitPos - tr.HitNormal
		util.Decal( "Blood", pos1, pos2 )
	end
	self.Overlord:SendLua("playsound('sassilization/units/unitLost.wav', 3)")
	self.Overlord = nil
end

function ENT:ExecuteUniqueMovement(phys)
	if (self.Ordered and !self.combatant and self.Grounded) or self.Decimated then
		local pos = self:GetPos()
		local dir = (self.Target - pos):Normalize()
		local forw = Vector( dir.x, dir.y, 0 )
		local pos1 = pos + ( forw * 15 )	//What's infront of the unit?

		local trace = { start = pos, endpos = pos1, filter = self, mask = MASK_SOLID_BRUSHONLY }	//Trace from the unit to what's infront of the unit.
		local tr = util.TraceLine( trace )

		if tr.HitWorld then	//Something is infront of the unit.
			local arg2 = math.abs( math.abs( Vector( 0, 0, 1 ):Angle().p ) - math.abs( tr.HitNormal:Angle().p ) ) > 85
			if arg2 then	//This something is not the terrain the unit is on.
				for i=1, 8 do
					local height = Vector( 0, 0, i*2 )
					trace.start = pos + height
					trace.endpos = pos1 + height
					tr = util.TraceLine( trace )
					local arg3 = !tr.HitWorld
					if arg3 then	//The thing infront of the unit is short enough to jump over.
						vel = ( (70+10*i)*Vector(0,0,1)+forw*60 )	//Make him hop
						self.Grounded = false
						phys:SetVelocity( vel )
						self:AnimState( ANIM_JUMP )
						break
					end
				end
			end
		end
	end
end