AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

local META = FindMetaTable("Player")

AccessorFunc( META, "m_iMonoliths", "Monoliths", FORCE_NUMBER )

META = nil


util.PrecacheModel( "models/jaanus/shieldmonolith.mdl" );

AccessorFunc( ENT, "m_iRecharge", "Recharge", FORCE_NUMBER )

function ENT:Initialize()
	
	self.index = self.index or 1
	self:SetModel( "models/jaanus/shieldmonolith.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_PUSH )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	if self:GetUp() == Vector( 0, 0, 1 ) then
		self:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
	end
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
	
	local r,g,b,a = self:GetColor()
	self:SetColor( r, g, b, 0 )
	self.claimed = false
	self.combatant = false
	self.Overlord = false
	self.SpawnedBy = false
	self.Dead = true
	self.Spawning = true
	self.Spawntime = 180
	self:SetRecharge( CurTime() )
	self.neighbors = {}
	
	self.maxhealth = BUILDINGS[self.index].health
	self.health = self.maxhealth
	self.clamp = 0
	
end

function ENT:CountNeighbors()
	
	local count = 0
	
	for k, v in pairs( self.neighbors ) do
		if ValidEntity( v ) and v:IsReady() then
			count = count + 1
		else
			self.neighbors[k] = nil
		end
	end
	
	return count
	
end

function ENT:CollectNeighbors()
	
	local nearby = ents.FindInSphere( self:GetPos(), 60 )
	for _, ent in pairs( nearby ) do
		if ent:GetClass() == "bldg_shieldmono" and ent:IsReady() then
			self:AddNeighbor( ent )
		end
	end
	
end

function ENT:AddNeighbor( ent )
	
	if !(ValidEntity( ent ) and ent:GetClass() == "bldg_shieldmono") then return end
	self.neighbors[ ent:EntIndex() ] = ent
	ent.neighbors[ self:EntIndex() ] = self
	
end

function ENT:ClearNeighbors()
	
	for k, v in pairs( self.neighbors ) do
		v.neighbors[ self:EntIndex() ] = nil
	end
	self.neighbors = {}
	
end

function ENT:CanProtect()
	
	local diff = CurTime() - self:GetRecharge() + math.Min( self:CountNeighbors(), 3 )
	return diff > 5
	
end

function ENT:Protect( hitpos )
	
	self:SetRecharge( CurTime() )
	
	self:EmitSound( "sassilization/spells/blockmiracle.wav" )
	
	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() + Vector( 0, 0, self:OBBMaxs().z ) )
		effectdata:SetStart( hitpos )
	util.Effect( "shield", effectdata, 1, 1 )
	
end

function ENT:Think()
	
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
		self.Spawning = nil
		self.Dead = false
		local effectdata = EffectData()
			effectdata:SetEntity( self )
		util.Effect( "materialize", effectdata, 1, 1 )
		self.Overlord:SetMonoliths( self.Overlord:GetMonoliths() or 0 + 1 )
		self:CollectNeighbors()
	end
	if self.Dead and !self.Spawning then return end
	if self:WaterLevel() > 0 then self:Raze() end
	if !self:GetOverlord() then self:Raze() end
	
end

function ENT:SetSpawner(ply)
	
	self.SpawnedBy = ply
	
	if(ply == self.SpawnedBy) then
		self:SetColor( ply:GetColor() ) //set to player's color
		self.claimed = true
		self.Overlord = ply
		self.combatant = true
		self:SetOwner( ply )
		local r,g,b,a = ply:GetColor()
		self:GetClamp( r, g, b )
	end
	
end

function ENT:Raze( info, inflictor )
	
	if self.Dead and self:IsReady() then return end
	if self.Overlord and !self.Spawning and info ~= "cleanup" then
		self.Overlord:SetMonoliths( self.Overlord:GetMonoliths() or 0 - 1 )
		if self.Overlord:GetNWInt("_gold") > 20 then
			self.Overlord:SetNWInt( "_gold", self.Overlord:GetNWInt("_gold") - 20)
			self.Overlord:SetFrags( self.Overlord:GetNWInt("_gold") )
		end
	end
	
	self.Spawning = false
	self:SetNWBool("spawning", false)
	self.Dead = true
	self:SetNWBool("dead", true)
	
	self:ClearNeighbors()
	
	if inflictor and inflictor:IsPlayer() and !self.Spawning then
		inflictor:SetNWInt("_gold", inflictor:GetNWInt("_gold")+20)
		inflictor.killcashbonus = inflictor.killcashbonus + 8
	end
	
	if ValidEntity( self ) then
		local function RemoveEntity( ent )
 			if (ent and ent:IsValid()) then
 				ent:Remove()
 			end
 		end
 		timer.Simple( 1, RemoveEntity, self )
		self:Extinguish()
	 	self:SetNotSolid( true )
 		self:SetMoveType( MOVETYPE_NONE )
	 	self:SetNoDraw( true )
		if info == "cleanup" then return end
		if info == "death" then
			local effectdata = EffectData()
				effectdata:SetEntity( self )
				effectdata:SetOrigin( self:GetPos() )
				effectdata:SetRadius( self:OBBMaxs().z*0.5 )
				effectdata:SetScale( 10 )
				effectdata:SetMagnitude( GIB_STONE )
			util.Effect( "gib_structure", effectdata )
		end
	end
	
	self:EmitSound( "sassilization/units/buildingbreak0"..math.random(1,2)..".wav" )
	
end
