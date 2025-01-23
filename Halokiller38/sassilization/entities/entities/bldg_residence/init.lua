AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheModel( "models/jaanus/citybuilding01.mdl" );
util.PrecacheModel( "models/jaanus/citybuilding02.mdl" );
util.PrecacheModel( "models/jaanus/citybuilding03.mdl" );

function ENT:Initialize()
	
	//the residence
	self:SetModel( "models/jaanus/citybuilding0"..math.random(1,3)..".mdl" )
	self:PhysicsInitBox( self:OBBMins(), self:OBBMaxs() )
	self:SetCollisionBounds( self:OBBMins(), self:OBBMaxs() )
	self:SetSolid( SOLID_BBOX )
	self:SetMoveCollide( MOVECOLLIDE_FLY_SLIDE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then phys:EnableMotion(false) end

	//Character
	self.maxhealth = math.random( 30, 40 )
	self.health = self.maxhealth
	self.clamp = 0

	if self.generation > 1 then return end
	if !(ValidEntity( self.parent ) and !self.parent:IsDead()) then return end

	self.Overlord = self.parent.Overlord
	
	local function expand( dir )
		if !ValidEntity( self ) then return end
		if self.Dead then return end
		self:Expand( dir )
	end
	local dir = (self:GetPos()-self.parent:GetPos()):Normalize():Angle() + Angle( 0, math.random( -90, 90 ), 0 )
	timer.Simple( 60, expand, dir )
	local dir = (self:GetPos()-self.parent:GetPos()):Normalize():Angle() + Angle( 0, math.random( -90, 90 ), 0 )
	timer.Simple( 90, expand, dir )
	local dir = (self:GetPos()-self.parent:GetPos()):Normalize():Angle() + Angle( 0, math.random( -90, 90 ), 0 )
	timer.Simple( 120, expand, dir )
end

function ENT:UpdateControl()

	local surroundings = ents.FindInSphere( self:GetPos(), 130 )
	if #surroundings > 0 then
		for _, ent in pairs(surroundings) do
			if	ent:GetClass() == "iron_mine"	||
				ent:GetClass() == "farm"	||
				ent:GetClass() == "bldg_gate"	||
				ent:GetClass() == "bldg_wall"	 then
				ent:UpdateControl()
			end
		end
	end
	
end

function ENT:Think()
	if self.Dead then return end
	if !self.Overlord then return end
	if self:WaterLevel() > 0 then self:Raze() end
	if self.Overlord and !(ValidEntity(self.Overlord) and self.Overlord:IsPlayer()) then
		self:Raze("cleanup")
	end
end

function ENT:Survivors( info )
	if !(self.Overlord and self.Overlord:IsValid()) then return end
	if info == "death" then
		local survivors = math.random( 1, 3 )
		for i=1, survivors do
			if self.Overlord:GetNWInt("_soldiers") + 1 >= unit_limit then return end
			local px = i*10 - (survivors*0.5)*10 - 10
			local py = math.Rand( -16, 16 )
			local trace = {}
			trace.start = self:GetPos() + Vector( px, py, 50 )
			trace.endpos = self:GetPos() - Vector( px, py, 50 )
 			local tr = util.TraceLine( trace )
			local ent = ents.Create( "unit_swordsman" )
			local ang = tr.HitNormal:Angle()
			ang.p = ang.p + 90
			ent:SetAngles( ang )
			ent.index = 0
			ent:Spawn()
			ent:Activate()
			ent:SetSpawner(self.Overlord)
			local min = ent:OBBMins()
			ent:SetPos( tr.HitPos - tr.HitNormal * ( min.z - 1 ) )
		end
	end
end

function ENT:Raze( info, inflictor )
	info = info or "death"
	if self.Dead then return end
	self.Dead = true
	self:SetNWBool("dead", true)
	
	if self.Overlord and self.Overlord:IsValid() then
		self.Overlord:CalculateUnitSupply()
		if self.Overlord:GetNWInt("_gold") > 10 then
			self.Overlord:SetNWInt( "_gold", self.Overlord:GetNWInt("_gold") - 10)
			self.Overlord:SetFrags( self.Overlord:GetNWInt("_gold") )
		end
	end

	if inflictor and inflictor:IsPlayer() then
		inflictor:SetNWInt("_gold", inflictor:GetNWInt("_gold")+8)
		if inflictor.killcashbonus then
			inflictor.killcashbonus = inflictor.killcashbonus + 2
		end
	end

	local surroundings = ents.FindInSphere( self:GetPos(), 132 )
	if #surroundings > 0 then
		for _, ent in pairs(surroundings) do
			if	ent:GetClass() == "iron_mine"	||
				ent:GetClass() == "farm"	||
				ent:GetClass() == "bldg_gate"	||
				ent:GetClass() == "bldg_wall"	 then
				ent:UpdateControl()
			end
		end
	end


	if ValidEntity( self ) then
		local ent = self
		ent:Extinguish()
	 	ent:SetNotSolid( true )
 		ent:SetMoveType( MOVETYPE_NONE )
	 	ent:SetNoDraw( true )
		if info == "cleanup" then
			local function RemoveEntity( ent )
 				if (ent and ent:IsValid()) then
 					ent:Remove()
 				end
 			end
 			timer.Simple( 1, RemoveEntity, ent )
		else
 			ent:Remove()
		end
		ent:Survivors(info)
		if info == "cleanup" then return end
		if info == "death" then
			local effectdata = EffectData()
				effectdata:SetEntity( self )
				effectdata:SetOrigin( self:GetPos() )
				effectdata:SetRadius( self:OBBMaxs().z*0.5 )
				effectdata:SetScale( 8 )
				effectdata:SetMagnitude( GIB_ALL )
			util.Effect( "gib_structure", effectdata )
		end
	end
	self:EmitSound( "sassilization/units/buildingbreak0"..math.random(1,2)..".wav" )
end

local function TraceHitsWater( trace )
	
	local tr = util.TraceLine( trace )
	if !tr.HitWorld then return end
	
	if util.PointContents( tr.HitPos ) & CONTENTS_WATER == CONTENTS_WATER then
		return tr, true
	end
	
	return tr
	
end

function ENT:Expand( dir )
	
	dir = dir or Angle( 0, math.random(360), 0 )
	
	if self.Dead then return end
	if !(ValidEntity(self.parent) and !self.parent.Dead) then return end
	
	local trace = {}
		local fwd = dir:Forward() * math.random( 32, 56 )
		trace.start = self:GetPos() + self:OBBCenter()
		trace.endpos = trace.start + self:GetRight() * fwd.x + self:GetForward() * fwd.y + self:GetUp() * 30
		trace.filter = self
		trace.mask = (SOLID)
	local tr = util.TraceLine( trace )
	if tr.Hit then return end
		trace.start = tr.HitPos
		trace.endpos = tr.HitPos + ( dir:Up() * -164 )
	local tr, water = TraceHitsWater( trace )
	if !tr or water then return end
	
	local exp = ents.Create( "bldg_residence" )
	exp.parent = self.parent
	exp.generation = self.generation + 1
	exp:SetPos( tr.HitPos )
	exp:SetOwner( self:GetOwner() )
	local ang = tr.HitNormal:Angle()
	ang.p = ang.p + 90
	if tr.HitNormal == Vector( 0, 0, 1 ) then
		ang.y = math.random( 0, 360 )
	end
	exp:SetAngles( ang )
	exp:Spawn()
	exp:Activate()
	
	local mins, maxs = exp:OBBMins(), exp:OBBMaxs()
	trace.filter = exp
	trace.start = tr.HitPos + tr.HitNormal + exp:GetRight() * mins.x + exp:GetForward() * mins.y + exp:GetUp() * maxs.z
	trace.endpos = trace.start + exp:GetUp() * (maxs.z + mins.z) * -2
	local trl, water = TraceHitsWater( trace )
	if !trl or water then--or (trl and trl.HitNormal:Dot(tr.HitNormal) < .3) then
		exp:Remove()
		return
	end
	trace.start = tr.HitPos + tr.HitNormal + exp:GetRight() * mins.x + exp:GetForward() * maxs.y + exp:GetUp() * maxs.z
	trace.endpos = trace.start + exp:GetUp() * (maxs.z + mins.z) * -2
	local trl, water = TraceHitsWater( trace )
	if !trl or water then--or (trl and trl.HitNormal:Dot(tr.HitNormal) < .3) then
		exp:Remove()
		return
	end
	trace.start = tr.HitPos + tr.HitNormal + exp:GetRight() * maxs.x + exp:GetForward() * maxs.y + exp:GetUp() * maxs.z
	trace.endpos = trace.start + exp:GetUp() * (maxs.z + mins.z) * -2
	local trl, water = TraceHitsWater( trace )
	if !trl or water then--or (trl and trl.HitNormal:Dot(tr.HitNormal) < .3) then
		exp:Remove()
		return
	end
	trace.start = tr.HitPos + tr.HitNormal + exp:GetRight() * maxs.x + exp:GetForward() * mins.y + exp:GetUp() * maxs.z
	trace.endpos = trace.start + exp:GetUp() * (maxs.z + mins.z) * -2
	local trl, water = TraceHitsWater( trace )
	if !trl or water then--or (trl and trl.HitNormal:Dot(tr.HitNormal) < .3) then
		exp:Remove()
		return
	end
	
	if exp:WaterLevel() > 0 then
		exp:Remove()
		return
	end
	
	local surroundings = ents.FindInSphere( tr.HitPos, 15 )
	local blocked = false
	if #surroundings > 0 then 
		for _, ent in pairs( surroundings ) do
			if ent != exp and !ent:IsWorld() then
				if (string.find( ent:GetClass(), "bldg_" ) || string.find( ent:GetClass(), "unit_" )) then
					exp:Remove()
					return
				end
			end
		end
	end
	
	if not ( tr.HitNormal:Angle().p <= 300 and tr.HitNormal:Angle().p >= 240 ) then
		exp:Remove()
		return
	end
	
	local pos = tr.HitPos
	local pos1 = pos + tr.HitNormal
	local pos2 = pos - tr.HitNormal
	util.Decal( "bricktile", pos1, pos2 )
	
	exp:SetSpawner( self.Overlord )
	exp:UpdateControl()
	self.Overlord:CalculateUnitSupply()
	
end