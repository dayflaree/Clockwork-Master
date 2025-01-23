AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheModel( "models/jaanus/townhall.mdl" );

function ENT:Initialize()
	
	//the city
	self.index = self.index or 1
	self:SetModel( "models/jaanus/horsie_onlybase.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_PUSH )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetColor( 255, 255, 255, 255 )

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	
	self.claimed = false
	self.combatant = false
	self.Overlord = false
	self.SpawnedBy = false
	self.Dead = true
	self.Spawning = true
	self.Spawnlength = 400
	self.Spawntime = self.Spawnlength

	//Character
	self.maxhealth = BUILDINGS[self.index].health
	self.health = self.maxhealth
	self.supply = BUILDINGS[self.index].supply
	self.clamp = 0
end

function ENT:Think()
	if self.Dead and !self.Spawning then return end
	if self.Spawning and self.Spawntime == self.Spawnlength then
		self:SetColor( 255, 255, 255, 255 )
		self.Spawntime = self.Spawntime - 1
		self:EmitSound( "sassilization/buildsound0"..math.random(1,3)..".wav" )
	elseif self.Spawning and self.Spawntime > 0 then
		self:SetColor( 255, 255, 255, 255 )
		self.Spawntime = self.Spawntime - 1
		local perc = self.Spawntime/self.Spawnlength
		if perc < 0.5 and !string.find( self:GetModel(), "horsie_stage1" ) then
			self:SetModel( "models/jaanus/horsie_stage1.mdl" )
		end
		return
	elseif self.Spawning and self.Spawntime <= 0 then
		self.Spawning = false
		self:SetNotSolid(true)
		self:SetNoDraw(true)
		self:SetMoveType(MOVETYPE_NONE)
		self.Overlord:SetNWInt( "_supplied", self.Overlord:GetNWInt( "_supplied" ) - self.supply )
		local ent = ents.Create( "unit_horsie" )
		ent:SetAngles( self:GetAngles() )
		ent:SetPos( self:GetPos() )
		ent.spawnpos = self:GetPos()
		ent.index = 7
		ent:Spawn()
		ent:Activate()
		ent:SetSpawner(self:GetOverlord())
		self:Remove()
		local effectdata = EffectData()
			effectdata:SetEntity( ent )
		util.Effect( "materialize", effectdata, 1, 1 )
	end
	if self:WaterLevel() > 0 then self:Raze() end
	if !self:GetOverlord():IsPlayer() then
		self:Raze()
	end
end

function ENT:SetSpawner(ply)
	self.SpawnedBy = ply
	if(!self.claimed) then
	if(ply == self.SpawnedBy) then
		self:SetColor( ply:GetColor() ) //set city to player's color
		self.claimed = true
		self.Overlord = ply
		self.Overlord:SetNWInt( "_supplied", self.Overlord:GetNWInt( "_supplied" ) + self.supply )
		self:SetOwner( ply )
		local r,g,b,a = ply:GetColor()
		self:GetClamp( r, g, b )
	end
	end
end

function ENT:Raze( info, inflictor )
	info = info or "death"
	if self.Dead and !self.Spawning then return end
	if inflictor and inflictor:IsPlayer() and !self.Spawning then
		inflictor:SetNWInt("_gold", inflictor:GetNWInt("_gold")+15)
		inflictor.killcashbonus = inflictor.killcashbonus + 5
	end
	self.Spawning = false
	self:SetNWBool("spawning", false)
	self.Dead = true
	self:SetNWBool("dead", true)
	if self and self:IsValid() then
		local ent = self
		ent:Extinguish()
		if info == "death" then
			local effectdata = EffectData()
				effectdata:SetEntity( self )
				effectdata:SetOrigin( self:GetPos() )
				effectdata:SetRadius( self:OBBMaxs().z*0.5 )
				effectdata:SetScale( 14 )
				effectdata:SetMagnitude( GIB_WOOD )
			util.Effect( "gib_structure", effectdata )
			ent:EmitSound( "sassilization/units/buildingbreak0"..math.random(1,2)..".wav" )
		elseif info == "refund" then
			local effectdata = EffectData()
				effectdata:SetEntity( ent )
			util.Effect( "dissolve", effectdata )
		end
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
	end
end