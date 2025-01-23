AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheModel( "models/jaanus/townhall.mdl" );

function ENT:Initialize()
	
	self.index = self.index or 1
	self:SetModel( "models/jaanus/townhall.mdl" )
	local min, max = self:OBBMins(), self:OBBMaxs()
	self:PhysicsInitBox( Vector( min.x, min.y, 0 ), Vector( max.x, max.y, 10 ) )
	self:SetCollisionBounds( Vector( min.x, min.y, 0 ), Vector( max.x, max.y, 10 ) )
	self:SetSolid( SOLID_BBOX )
	self:SetMoveCollide( MOVECOLLIDE_FLY_SLIDE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:DrawShadow( false )
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then phys:EnableMotion(false) end
	
	self.claimed = false
	self.combatant = false
	self.Overlord = false
	self.SpawnedBy = false
	self.Dead = true
	self.Spawning = true
	self.Spawntime = 180
	self.Expansions = {}
	self.NextExpansion = false
	
	//Character
	self.maxhealth = BUILDINGS[self.index].health
	self.health = self.maxhealth
	self.clamp = 0
	
end

function ENT:Think()
	if self.Dead and !self.Spawning then return end
	local r,g,b,a = self:GetColor()
	if self.Spawning and self.Spawntime == 180 then
		self:SetNWBool("spawning",true)
		self.Spawntime = self.Spawntime - 1
		self:SetColor( r, g, b, 255 - self.Spawntime )
		local effectdata = EffectData()
			effectdata:SetEntity( self )
			effectdata:SetOrigin( self:GetPos())
		util.Effect( "rivera", effectdata )
		self:EmitSound( "sassilization/buildsound0"..math.random(1,3)..".wav" )
	elseif self.Spawning and self.Spawntime > 0 then
		self.Spawntime = self.Spawntime - 1
		self:SetColor( r, g, b, 255 - self.Spawntime )
		return
	elseif self.Spawning and self.Spawntime <= 0 then
		self:SetColor( r, g, b, 255 )
		self:SetNWBool("spawning",false)
		self.Spawning = false
		self.Dead = false
		local effectdata = EffectData()
			effectdata:SetEntity( self )
		util.Effect( "materialize", effectdata, 1, 1 )
		self.Overlord:SetNWInt("_cities", self.Overlord:GetNWInt("_cities") + 1)
		self.Overlord:CalculateUnitSupply()
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
		local function expand( dir )
			if !self or !self:IsValid() then return end
			if self.Dead then return end
			self:Expand( dir )
		end
		timer.Simple( math.random(50,90), expand, Angle( 0, math.random( 0, 360 ), 0 ) )
		timer.Simple( math.random(50,90), expand, Angle( 0, math.random( 0, 360 ), 0 ) )
		timer.Simple( math.random(50,90), expand, Angle( 0, math.random( 0, 360 ), 0 ) )
		timer.Simple( math.random(50,90), expand, Angle( 0, math.random( 0, 360 ), 0 ) )
		self.NextExpansion = CurTime() + math.random(60, 120)
	end
	if self:WaterLevel() > 0 then self:Raze() end
	if self.Overlord and !(ValidEntity(self.Overlord) and self.Overlord:IsPlayer()) then
		self:Raze("cleanup")
	end
	if self.NextExpansion and CurTime() > self.NextExpansion then
		self:Expand( Angle( 0, math.random( 0, 360 ), 0 ) )
		self.NextExpansion = CurTime() + math.random(60, 120)
	end
end

function ENT:SetSpawner(ply)
	self.SpawnedBy = ply
	if(!self.claimed) then
	if(ply == self.SpawnedBy) then
		self:SetColor( ply:GetColor() ) //set city to player's color
		self.claimed = true
		self.Overlord = ply
		self.combatant = true
		self:SetOwner( ply )
		local r,g,b,a = ply:GetColor()
		self:GetClamp( r, g, b )
	end
	end
end

function ENT:Survivors( info )
	if !(self.Overlord and self.Overlord:IsValid()) then return end
	if info == "death" then
		local survivors = math.random( 3, 5 )
		for i=1, survivors do
			if self.Overlord:GetNWInt("_soldiers") + 1 >= unit_limit then return end
			local px = i*10 - (survivors*0.5)*10 - 10
			local py = math.Rand( -16, 16 )
			local trace = {}
			trace.start = self:GetPos() + Vector( px, py, 20 )
			trace.endpos = self:GetPos() + Vector( px, py, -100 )
			trace.mask = (SOLID)
 			local tr = util.TraceLine( trace )
			local ent = ents.Create( "unit_peasant" )
			local min = ent:OBBMins()
			ent:SetPos( tr.HitPos + tr.HitNormal * min.z )
			ent:SetAngles( Angle( 0, 0, 0 ) )
			ent.index = 0
			ent:Spawn()
			ent:Activate()
			ent:SetSpawner(self.Overlord)
		end
	end
end

function ENT:Raze( info, inflictor )
	info = info or "death"
	if self.Dead and !self.Spawning then return end
	if ValidEntity( self.Overlord ) and info ~= "cleanup" then
		if !self.Spawning then
			self.Overlord:SetNWInt("_cities", self.Overlord:GetNWInt("_cities") - 1)
			self.Overlord:CalculateUnitSupply()
			if self.Overlord:GetNWInt("_gold") > 20 then
				self.Overlord:SetNWInt( "_gold", self.Overlord:GetNWInt("_gold") - 20)
			end
		end
	end
	if inflictor and inflictor:IsPlayer() and !self.Spawning then
		inflictor:SetNWInt("_gold", inflictor:GetNWInt("_gold")+15)
		inflictor.killcashbonus = inflictor.killcashbonus + 5
	end
	self.Spawning = false
	self:SetNWBool("spawning", false)
	self.Dead = true
	self:SetNWBool("dead", true)
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
		if info == "death" then
			local effectdata = EffectData()
				effectdata:SetEntity( self )
				effectdata:SetOrigin( self:GetPos() )
				effectdata:SetRadius( self:OBBMaxs().z*0.5 )
				effectdata:SetScale( 14 )
				effectdata:SetMagnitude( GIB_ALL )
			util.Effect( "gib_structure", effectdata )
			ent:EmitSound( "sassilization/units/buildingbreak0"..math.random(1,2)..".wav" )
		end
		ent:Survivors(info)
	 	ent:SetNotSolid( true )
 		ent:SetMoveType( MOVETYPE_NONE )
	 	ent:SetNoDraw( true )
		local function RemoveEntity( ent )
 			if ValidEntity( ent ) then
 				ent:Remove()
 			end
 		end
 		timer.Simple( .1, RemoveEntity, ent )
	end
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
	exp.parent = self
	exp.generation = 1
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
	trace.endpos = trace.start + exp:GetUp() * (maxs.z + math.abs(mins.z)) * -2
	local trl, water = TraceHitsWater( trace )
	if !trl or water then--or (trl and trl.HitNormal:Dot(tr.HitNormal) < .3) then
		exp:Remove()
		return
	end
	trace.start = tr.HitPos + tr.HitNormal + exp:GetRight() * mins.x + exp:GetForward() * maxs.y + exp:GetUp() * maxs.z
	trace.endpos = trace.start + exp:GetUp() * (maxs.z + math.abs(mins.z)) * -2
	local trl, water = TraceHitsWater( trace )
	if !trl or water then--or (trl and trl.HitNormal:Dot(tr.HitNormal) < .3) then
		exp:Remove()
		return
	end
	trace.start = tr.HitPos + tr.HitNormal + exp:GetRight() * maxs.x + exp:GetForward() * maxs.y + exp:GetUp() * maxs.z
	trace.endpos = trace.start + exp:GetUp() * (maxs.z + math.abs(mins.z)) * -2
	local trl, water = TraceHitsWater( trace )
	if !trl or water then--or (trl and trl.HitNormal:Dot(tr.HitNormal) < .3) then
		exp:Remove()
		return
	end
	trace.start = tr.HitPos + tr.HitNormal + exp:GetRight() * maxs.x + exp:GetForward() * mins.y + exp:GetUp() * maxs.z
	trace.endpos = trace.start + exp:GetUp() * (maxs.z + math.abs(mins.z)) * -2
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