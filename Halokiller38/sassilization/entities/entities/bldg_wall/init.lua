AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


util.PrecacheModel( "models/jaanus/tower.mdl" );
util.PrecacheModel( "models/jaanus/wall.mdl" );

function ENT:Initialize()
	
	self.index = self.index or 1
	if !self.filler then
		self.Build = {}
		self:SetModel( "models/jaanus/tower.mdl" )
		self:SetAngles( Angle( 0, 0, 0 ) )
	end
	
	if self.filler then
		self:PhysicsInitBox( Vector( -3, -3, -10 ), Vector( 3, 3, 15 ) )
		self:SetCollisionBounds( Vector( -3, -3, -10 ), Vector( 3, 3, 15 ) )
	else
		self:PhysicsInit( SOLID_VPHYSICS )
	end
	
	self:SetSolid( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_PUSH )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	self:SetColor( 255,255, 255,255 )
	self:DrawShadow( false )
	
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:EnableMotion(false)
		phys:Sleep()
	end

	self.claimed = false
	self.Overlord = false
	self.SpawnedBy = "nothing"
	self.gates = {}
	self.spawnpos = self:GetPos()
	self.neighbors = self.neighbors or {}
	self.height = self:OBBMaxs().z
	self.plummetlimit = self:GetPos().z - self.height
	self.plummetrate = self.filler and 0 or 2

	self.Dead = false

	//Character
	self.maxhealth = self.filler and BUILDINGS[self.index].health or BUILDINGS[self.index].health*0.5
	self.health = self.maxhealth
	self.clamp = 0

	self.min = BUILDINGS[self.index].min
	
end

function ENT:Think()
	if self.Plummeted then
		if self:GetPos().z < self.plummetlimit then
			self:Raze("death")
		end
		if math.abs(self.plummetlimit - self:GetPos().z) < self.height*0.9 then
			for _, ent in pairs( self.neighbors ) do
				if ValidEntity( ent ) and !ent:IsDead() and !ent.Plummeted then
					ent.Plummeted = true
				end
			end
		end
		self:SetPos( self:GetPos() - Vector( 0, 0, self.plummetrate ) )
		self.plummetrate = self.plummetrate + .2
	end
	if !self.Build then return end
	if self:IsDead() then return end
	if table.Count(self.Build) > 0 then
		for k, wall in pairs( self.Build ) do
			if CurTime() >= wall.time then
				local ent = ents.Create( "bldg_wall" )
				ent:SetModel( "models/jaanus/wall.mdl" )
				ent.filler = true
				ent.parent = wall.parent
				ent.neighbors = {}
				if wall.neighbor then
					table.insert( ent.neighbors, wall.neighbor )
					table.insert( wall.neighbor.neighbors, ent )
				end
				if wall.last then
					table.insert( ent.neighbors, wall.last )
					table.insert( wall.last.neighbors, ent )
				end
				ent:SetPos( wall.pos )
				ent.index = 2
				ent:Spawn()
				ent:Activate()
				ent:SetAngles( wall.ang )
				if ValidEntity( self.Overlord) then
					ent:SetOverlord( self.Overlord )
					ent:SetControl( self.Overlord )
				else
					ent:RemoveControl()
				end
				if self.Build[k-1] then
					self.Build[k-1].neighbor = ent
				end
				self.Build[ k ] = nil
				self:NextThink( CurTime() )
				return true
			end
		end
	end
end

function ENT:UpdateControl()
	if !self or !self or !self:IsValid() then return end
	if self:IsDead() then return end
	if !self.Overlord then
		local ents = ents.FindInSphere( self:GetPos(), 130 )
		if table.Count( ents ) == 0 then return end
		for _, ent in pairs( ents ) do
			if (	ent:GetClass() == "bldg_city"		||
				ent:GetClass() == "bldg_residence"	||
				ent:GetClass() == "bldg_shrine") and ent:IsReady() and ent:GetOverlord() then
				self:SetControl( ent:GetOverlord() )
				break
			end
		end
	else
		local ents = ents.FindInSphere( self:GetPos(), 128 )
		local cities = {}
		for _, ent in pairs( ents ) do
			if (	ent:GetClass() == "bldg_city"		||
				ent:GetClass() == "bldg_residence"	||
				ent:GetClass() == "bldg_shrine") and !ent:IsDead() and ent:GetOverlord() == self.Overlord then
				table.insert( cities, ent )
			end
		end
		if #cities <= 0 then
			self:RemoveControl()
		end
	end
end

function ENT:SetControl( overlord )
	if !(ValidEntity(overlord) and overlord:IsPlayer()) then return end
	self:SetOwner( overlord )
	self.Overlord = overlord
	self.Overlord:SetNWInt("_fences", self.Overlord:GetNWInt("_fences") + 1)
	local r,g,b,a = self:GetOverlord():GetColor()
	self:GetClamp( r, g, b )
	local d = self.clamp - ( self.clamp * math.Clamp( self.health , 0 , self.maxhealth ) / self.maxhealth )
	r = r + d
	g = g + d
	b = b + d
	self:SetColor( r,g,b,a )
end

function ENT:RemoveControl()
	self:SetColor( 250, 250, 250, 255 )
	if !self.Overlord then return end
	if self.Overlord:IsPlayer() then
		self.Overlord:SetNWInt("_fences", self.Overlord:GetNWInt("_fences") - 1)
	end
	self.Overlord = nil
	self:SetOwner(NULL)
	self:UpdateControl()
end

function ENT:SetOverlord(ply)
	if !ValidEntity( ply ) then return end
	self.SpawnedBy = ply
	if !self.claimed then
		if ply:IsPlayer() then
			self:SetColor( ply:GetColor() ) //set to player's color
			self.claimed = true
			self.Overlord = ply
			self:SetOwner( ply )
			local r,g,b,a = ply:GetColor()
			self:GetClamp( r, g, b )
		end
	end
end

function ENT:SetSpawner(ply)
	
	self:SetOverlord( ply )

	if ply:KeyDown( IN_SPEED ) then return end

	local distance = wall_distance
	local wall1 = false
	local wall2 = false
	local neighbors = {}
	local Ents = ents.FindInSphere( self:GetPos(), wall_distance )
	if table.Count( Ents ) == 0 then return end
	for _, ent in pairs( Ents ) do
		if ent:GetClass() == "bldg_wall" and !ent:IsDead() and !ent.Plummeted and ent != self and !ent.filler then
			if ent:GetOverlord() == self:GetOverlord() || table.HasValue( alliances[self:GetOverlord()], ent:GetOverlord() ) then
				local dist = self:GetPos():Distance(ent:GetPos())
				if dist <= distance then
					wall1 = ent
					distance = dist
				end
				if dist <= wall_spacing+3 then
					table.insert( neighbors, ent )
				end
			end
		end
	end
	if !wall1 then return end
	if distance < wall_spacing+3 || math.Round( distance / wall_spacing ) < 1 then
		for k, v in pairs( neighbors ) do
			table.insert( v.neighbors, self )
			table.insert( self.neighbors, v )
		end
		return
	end
	local distance1 = distance
	distance = wall_distance
	for _, ent in pairs( Ents ) do
		if ent:GetClass() == "bldg_wall" and !ent:IsDead() and !ent.Plummeted and ent != self and ent ~= wall1 and !ent.filler then
			if ent:GetOverlord() == self:GetOverlord() || table.HasValue( alliances[self:GetOverlord()], ent:GetOverlord() ) then
				if self:GetPos():Distance(ent:GetPos()) <= distance then
					wall2 = ent
					distance = self:GetPos():Distance(ent:GetPos())
				end
			end
		end
	end
	if wall2 and ((wall1:GetPos()+wall2:GetPos())*0.5):Distance(self:GetPos()) < 20 and wall1:GetPos():Distance(wall2:GetPos()) < wall_distance*0.5  then
		local trace = {}
		trace.start = wall1:GetPos() + Vector( 0, 0, 5 )
		trace.endpos = wall2:GetPos() + Vector( 0, 0, 5 )
		trace.filter = {self, wall1}
		trace.filter = table.Add( trace.filter, player.GetAll() )
		local tr = util.TraceLine( trace )
		if ValidEntity( tr.Entity ) and tr.Entity == wall2 then
			self:Connect( ply, wall1, wall2 )
			self:Raze("cleanup")
			return
		end
	end
	self:Connect( ply, self, wall1 )
end

function ENT:Connect(ply, wall1, wall2)
	local vStart = wall1:GetPos() + ( wall1:GetUp() * 10)
	local vEnd = wall2:GetPos() + ( wall2:GetUp() * 10)
	local distance = math.Round( vStart:Distance(vEnd) )
	local trace = {}
	trace.start = vStart
	trace.endpos = vEnd
	trace.mask = MASK_NPCWORLDSTATIC
	local tr = util.TraceLine( trace )
	if tr.HitWorld then return end
	if ValidEntity(wall1) then
		local count = math.Round( distance / wall_spacing )
		local angle = (vEnd - vStart):Normalize()
		local Points = GetGaps( vStart, vEnd, angle, count, distance, self.min )
		if !Points then return end
		local mygold = ply:GetNWInt("_gold")
		local myiron = ply:GetNWInt("_iron")
		local myfood = ply:GetNWInt("_food")
		local gold = BUILDINGS[2].gold * #Points
		local iron = BUILDINGS[2].iron * #Points
		local food = BUILDINGS[2].food * #Points
		if wall1 == self then
			gold = gold + BUILDINGS[2].gold
			iron = iron + BUILDINGS[2].iron*2
			food = food + BUILDINGS[2].food*2
		end
		if myiron < iron || myfood < food then
			ply:ChatPrint("You do not have enough resources to build this wall.")
			ply:ChatPrint( "wall cost "..gold.." gold, "..iron.." iron, "..food.." food." )
			self:Raze("cleanup")
			ply:SetNWInt("_food", ply:GetNWInt("_food") + BUILDINGS[2].food)
			ply:SetNWInt("_iron", ply:GetNWInt("_iron") + BUILDINGS[2].iron)
			ply:SetNWInt("_gold", ply:GetNWInt("_gold") + BUILDINGS[2].gold)
			return
		end
		wall1.Build = wall1.Build or {}
		for k, v in ipairs( Points ) do
			local wall = {}
			wall.time = CurTime() + (k-1)*0.2
			wall.neighbor = wall1
			wall.parent = wall1
			wall.pos = v
			wall.ang = Angle( 0, angle:Angle().y+90, 0 )
			if k == #Points then
				wall.last = wall2
			end
			wall1.Build[#Points-(k-1)] = wall
		end
		ply:DeductResource("_food", food)
		ply:DeductResource("_iron", iron)
		ply:SetNWInt("_gold", ply:GetNWInt("_gold") - gold)
		ply:SetFrags( ply:GetNWInt("_gold") )
		ply:ChatPrint( "wall cost "..gold.." gold, "..iron.." iron, "..food.." food." )
		if #wall1.Build == 0 then
			table.insert( wall1.neighbors, wall2 )
			table.insert( wall2.neighbors, wall1 )
		end
	end
end

function ENT:Upgrade(id, ...)
	local pl = self.Overlord
	if id == "gate" then
		
		local food, iron, gold = BUILDINGS[3].food, BUILDINGS[3].iron, BUILDINGS[3].gold
		
		local pos = self:GetPos()
		local ang = Angle( 0, self:GetAngles().y, 0 )
		local ent = ents.Create( "bldg_"..id )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		
		ent.index = 3
		ent.ang = ang
		ent.type = BUILDINGS
		ent:Spawn()
		ent:Activate()
		ent:SetSpawner(pl)
		
		umsg.Start( "ClearGatePreview", pl )
			for k, v in pairs( arg[1] ) do
				umsg.Short( v:EntIndex() )
				v:Raze("cleanup")
			end
			for k, v in pairs( arg[2] ) do
				umsg.Short( v:EntIndex() )
				v:SetModel("models/jaanus/tower.mdl")
				v:PhysicsInit( SOLID_VPHYSICS )
				v:SetSolid( SOLID_VPHYSICS )
				v:GetPhysicsObject():EnableMotion(false)
				if v.filler then
					local pos = v:GetPos()
					v.filler = false
				end
				table.insert( v.gates, ent )
			end
		umsg.End()
		
		pl:DeductResource("_food", food)
		pl:DeductResource("_iron", iron)
		pl:SetNWInt("_gold", pl:GetNWInt("_gold") - gold)
		pl:SendLua("playsound( 'sassilization/buildascend.wav', 1 )")
		pl:SendLua("ents.GetByIndex("..self:EntIndex()..").oldnodraw = 'true'")
		self:Raze("cleanup")
	end
end

function ENT:Raze( info, inflictor )
	info = info or "death"
	if self.Dead then return end
	self.Spawning = false
	self:SetNWBool("spawning", false)
	self.Dead = true
	self:SetNWBool("dead", true)
	if ValidEntity(inflictor) and inflictor:IsPlayer() then
		inflictor:SetNWInt("_gold", inflictor:GetNWInt("_gold")+8)
		inflictor.killcashbonus = inflictor.killcashbonus + 1
	end
	local pl = self.Overlord
	if ValidEntity(pl) and pl:IsPlayer() then
		if info == "refund" then
			local perc = self.health/self.maxhealth
			pl:SetNWInt("_food", BUILDINGS[self.index].food*perc+pl:GetNWInt("_food"))
			pl:SetNWInt("_iron", BUILDINGS[self.index].iron*perc+pl:GetNWInt("_iron"))
		end
	end
	if ValidEntity( self ) then
		if info == "death" then
			self:EmitSound( "sassilization/units/wallbreak0"..math.random(1,2)..".wav" )
			local effectdata = EffectData()
				effectdata:SetEntity( self )
				effectdata:SetOrigin( self.spawnpos )
				effectdata:SetRadius( self:OBBMaxs().z*0.5 )
				effectdata:SetScale( self.Plummeted and 8 or 16 )
				effectdata:SetMagnitude( GIB_STONE )
			util.Effect( "gib_structure", effectdata )
		elseif info == "refund" then
			for k, v in pairs( self.neighbors ) do
				if ValidEntity( v ) then
					if v.filler then
						local effectdata = EffectData()
							effectdata:SetEntity( v )
						util.Effect( "dissolve", effectdata, true, true )
						v:Raze("refund")
					end
				end
			end
		end

		for k, v in pairs( self.gates ) do
			if ValidEntity( v ) and !v:IsDead() then
				v:Raze(info)
			end
		end
		self:Extinguish()
	 	self:SetNotSolid( true )
 		self:SetMoveType( MOVETYPE_NONE )
	 	self:SetNoDraw( true )
		local function RemoveEntity( self )
 			if ValidEntity( self ) then
 				self:Remove()
 			end
 		end
 		timer.Simple( 1, RemoveEntity, self )

	end
end

function GetGaps( startpos, endpos, angle, steps, distance, min )
	local trace, tr, i, chunk, res, res2 = {}, {}, nil, distance / steps, {}, {}
	for i=1, steps - 1 do
		trace.start = startpos + ( angle:Angle():Up() * 10 ) + ( i * angle * chunk )
		trace.endpos = trace.start + Vector( 0, 0, -100 )
		trace.mask = MASK_NPCWORLDSTATIC
		tr = util.TraceLine( trace )

		trace.mask = MASK_WATER

		local traceline = util.TraceLine(trace)

		if traceline.Hit then
			if tr.Fraction > traceline.Fraction then return end
		end

		if tr.Hit then
			table.insert( res, tr.HitPos - (tr.HitNormal * min) )
			table.insert( res2, tr.HitNormal )
		end
	end
	return res, res2
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

function ENT:DealDamage( amount, attacker )
	if ( not (self and self:IsValid()) ) then return end
	if !self.Overlord or !self.Overlord:IsPlayer() then return end
	if !attacker or !attacker:IsValid() or attacker:IsDead() then return end
	if self.health - amount > 0 then
		self.health = self.health - amount
		self:SetNWInt( "health", self.health )
		local r,g,b,a = self.Overlord:GetColor()
		local d = self.clamp - ( self.clamp * math.Clamp( self.health , 0 , self.maxhealth ) / self.maxhealth )
		r = r + d
		g = g + d
		b = b + d
		self:SetColor( r,g,b,a )
	else
		self:Raze()
		attacker.combatant = false
	end
end

function ENT:GetOverlord()
	return self.Overlord
end
