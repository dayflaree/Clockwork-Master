AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheModel( "models/jaanus/archertower_01.mdl" );
util.PrecacheModel( "models/jaanus/archertower_02.mdl" );
util.PrecacheModel( "models/jaanus/archertower_03.mdl" );

function ENT:Initialize()
	
	//the tower
	self.index = self.index or 0
	self:SetModel( "models/jaanus/archertower_01.mdl" )
	self:PhysicsInitBox( self:OBBMins(), self:OBBMaxs() )
	self:SetCollisionBounds( self:OBBMins(), self:OBBMaxs() )
	self:SetSolid( SOLID_BBOX )
	self:SetMoveCollide( MOVECOLLIDE_FLY_SLIDE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetColor( 255, 255, 255, 255 )

	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then phys:EnableMotion(false) end

	//Characteristics
	self.maxhealth = BUILDINGS[self.index].health
	self.health = self.maxhealth
	self.damage = 8
	self.range = 50
	self.delay = 12
	self.clamp = 0

	self.combatant = false
	self.level = 1
	self.upgraded = false
	self.Overlord = false
	self.SpawnedBy = false
	self.Dead = false
	self.Clock = 0
	self.NextCheck = CurTime()
	
end

function ENT:Think()

	if self.Dead then return end
	if !self then return end
	if !self:IsValid() then return end
	if !self:GetPhysicsObject() then return end

	local phys = self:GetPhysicsObject()
	local pos = self:GetPos()
	
	//////////
	//COMBAT//
	//////////
	
	self.NextCheck = self.NextCheck or CurTime()
	if !(CurTime() > self.NextCheck) then return end
	self.NextCheck = CurTime() + 4
	
	if !self.combatant then self.Clock = CurTime() end
	if CurTime() >= self.Clock then

		local entities = ents.FindInSphere( pos - Vector( 0, 0, self.range ), self.range*1.5 )
		entities = table.Add( entities, ents.FindInSphere( pos + Vector( 0, 0, self.range ), self.range*1.5 ) )
		local enemies = {}
		for _, entitie in pairs( entities ) do
			if (ValidEntity( entitie ) and entitie ~= self and IsAttackable( entitie ) and entitie:GetOverlord() and entitie:GetOverlord() ~= self:GetOverlord()) and !entitie:IsDead() and entitie:Visible( self ) then
				if  pos:Distance( entitie:GetPos() ) > 12 then
					if !table.HasValue( alliances[self:GetOverlord()], entitie:GetOverlord() ) then
						local dir = (entitie:GetPos() - (pos+Vector(0,0,26))):Normalize()
						local trace = {}
						trace.start = pos+Vector(0,0,26)+Vector(dir.x,dir.y,0):Normalize()*4
						trace.endpos = entitie:GetPos()
						trace.mask = MASK_SOLID_BRUSHONLY
						local tr = util.TraceLine( trace )
						if table.HasValue( ents.FindInSphere( tr.HitPos, 1.5 ), entitie ) then
							table.insert( enemies, entitie )
						end
					end
				end
			end
		end
		if #enemies == 0 then
			self.combatant = false
			self.NextCheck = CurTime() + 4
			return
		else
			self.combatant = true
			self.BlockClock = false
			self.NextCheck = CurTime()
			for _, ent in pairs( entities ) do
				if ent:GetClass() == "bldg_tower" and ent:GetOverlord() == self:GetOverlord() then
					ent.NextCheck = CurTime()
					ent:Think()
				end
			end
		end

		local max = self.range * 0.1
		local count = 0
		for _, enemy in pairs( enemies ) do
			if count < max then
				local function attack( self, enemy )
					if !(ValidEntity( self ) and !self:IsDead()) then return end
					if !(ValidEntity( enemy ) and !enemy:IsDead()) then return end
					enemy:DealDamage( self.damage, self )
					local dir = (enemy:GetPos() - (pos+Vector(0,0,26))):Normalize()
					dir = (enemy:GetPos() - (pos+Vector(0,0,26)+Vector( dir.x, dir.y, 0 )*8)):Normalize()
					self:shootArrow( pos+Vector(0,0,26)+Vector( dir.x, dir.y, 0 )*8, enemy:GetPos(), dir:Angle() )
					self:EmitSound( "sassilization/units/arrowfire0"..math.random( 1,2 )..".wav" )
				end
				timer.Simple( math.Rand( 0, self.delay * (#enemies/max) ), attack, self, enemy )
				count = count + 1
			else
				break
			end
		end
		
		if self.combatant then self.Clock = CurTime() + self.delay * (count/max) end
		
		return
		
	end

	if !self:GetOverlord() then self:Raze() end
	
end

function ENT:OnDamaged( amount )
	
	self.NextCheck = CurTime()
	
end

function ENT:Upgrade()
	if self.Dead then return end
	if self.upgraded then return end
	self.NextCheck = CurTime()
	self.level = self.level + 1
	local food = BUILDINGS[self.index].food
	local iron = BUILDINGS[self.index].iron
	local gold = BUILDINGS[self.index].gold
	if self.level == 2 then
		self:SetModel( "models/jaanus/archertower_02.mdl" )
		self.maxhealth = self.maxhealth * 1.5
		self.health = self.maxhealth
		self.damage = 9
		self.range = 60
		self.delay = 11
		self.Overlord:DeductResource("_food", food)
		self.Overlord:DeductResource("_iron", iron)
		self.Overlord:DeductResource("_gold", gold, true)
		return
	elseif self.level == 3 then
		self:SetModel( "models/jaanus/archertower_03.mdl" )
		self.maxhealth = self.maxhealth * 1.5
		self.health = self.maxhealth
		self.damage = 10
		self.range = 80
		self.delay = 10
		self.Overlord:DeductResource("_food", food)
		self.Overlord:DeductResource("_iron", iron)
		self.Overlord:DeductResource("_gold", gold, true)
		self.upgraded = true
		return
	end
end

function ENT:SetSpawner(ply)
	if !ply:IsPlayer() then return end
	self.SpawnedBy = ply
	self:SetColor(ply:GetColor())
	self.Overlord = ply
	self:SetOwner( ply )
	local r,g,b,a = ply:GetColor()
	self:GetClamp( r, g, b )
end

function ENT:GetClamp( r, g, b )
	local function winner( n, m )
		if m > n then
			return m
		else
			return n
		end
	end
	local small = winner( r, g )
	small = winner( small, b )
	local clamp = 255 - small
	self.clamp = clamp
end

function ENT:shootArrow( spos, epos, ang )
	local arr = ents.Create( "arrow" )
	arr:SetPos( spos )
	arr.PosStart = spos
	arr.PosTarget = epos
	arr.AngStart = ang + Angle( 90, 0, 0 )
	arr:SetOwner( self )
	arr:Spawn()
	arr:Activate()
	arr:SetSpawner( self:GetOverlord() )
end

function ENT:Raze( info, inflictor )
	info = info or "death"
	if self.Dead and self:IsReady() then return end
	self.Spawning = false
	self:SetNWBool("spawning", false)
	self.Dead = true
	self:SetNWBool("dead", true)
	if inflictor and inflictor:IsPlayer() then
		inflictor:SetNWInt("_gold", inflictor:GetNWInt("_gold")+15)
		inflictor.killcashbonus = inflictor.killcashbonus + 3
	end
	if ValidEntity( self ) then
		if info == "death" then
			local effectdata = EffectData()
				effectdata:SetEntity( self )
				effectdata:SetOrigin( self:GetPos() )
				effectdata:SetRadius( self:OBBMaxs().z*0.5 )
				effectdata:SetScale( 10 )
				effectdata:SetMagnitude( GIB_WOOD )
			util.Effect( "gib_structure", effectdata )
		end
		local ent = self
		local function RemoveEntity( ent )
 			if ValidEntity(ent) then
 				ent:Remove()
 			end
 		end
 		timer.Simple( 1, RemoveEntity, ent )
		ent:Extinguish()
	 	ent:SetNotSolid( true )
 		ent:SetMoveType( MOVETYPE_NONE )
	 	ent:SetNoDraw( true )
	end
end