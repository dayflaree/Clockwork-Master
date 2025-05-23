AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )




util.PrecacheModel( "models/jaanus/altar.mdl" );



function ENT:Initialize()
	
	//the shrine
	self.index = self.index or 1
	self:SetModel( "models/jaanus/altar.mdl" )
	self:PhysicsInitBox( self:OBBMins(), self:OBBMaxs() )
	self:SetCollisionBounds( self:OBBMins(), self:OBBMaxs() )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetMoveType( MOVETYPE_PUSH )
	self:DrawShadow( false )
	
	local curAng = self:GetAngles()
	if curAng:Up() == Vector( 0, 0, 1 ) then
		self:SetAngles( Angle( curAng.p, math.random( 0, 360 ), curAng.r ) )
	end

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
		phys:Sleep()
	end

	self.claimed = false
	self.combatant = false
	self.Overlord = false
	self.SpawnedBy = false
	self.Dead = true
	self.Spawning = true
	self.Spawntime = 180

	//Character
	self.maxhealth = BUILDINGS[self.index].health
	self.health = self.maxhealth
	self.clamp = 0
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
		self.Spawning = false
		self.Dead = false
		local effectdata = EffectData()
			effectdata:SetEntity( self )
		util.Effect( "materialize", effectdata, 1, 1 )
		self.Overlord:SetNWInt("_shrines", self.Overlord:GetNWInt("_shrines") + 1) //add to the count
		self.Overlord:SendLua("playsound('sassilization/templeComplete.wav', -1)")
	end
	if self.Dead and !self.Spawning then return end
	if self:WaterLevel() > 0 then self:Raze() end
	if !self:GetOverlord() then self:Raze() end
	
end

function ENT:SetSpawner(ply)
	self.SpawnedBy = ply
	if(!self.claimed) then
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
end

function ENT:Raze( info, inflictor )
	if self.Dead and self:IsReady() then return end
	if self.Overlord and !self.Spawning and info ~= "cleanup" then
		self.Overlord:SetNWInt("_shrines", self.Overlord:GetNWInt("_shrines") - 1)
		if self.Overlord:GetNWInt("_gold") > 20 then
			self.Overlord:SetNWInt( "_gold", self.Overlord:GetNWInt("_gold") - 20)
			self.Overlord:SetFrags( self.Overlord:GetNWInt("_gold") )
		end
	end
	self.Spawning = false
	self:SetNWBool("spawning", false)
	self.Dead = true
	self:SetNWBool("dead", true)
	if inflictor and inflictor:IsPlayer() and !self.Spawning then
		inflictor:SetNWInt("_gold", inflictor:GetNWInt("_gold")+20)
		inflictor.killcashbonus = inflictor.killcashbonus + 8
	end
	local surroundings = ents.FindInSphere( self:GetPos(), 132 )
	if #surroundings > 0 then
		for _, ent in pairs(surroundings) do
			if	ent:GetClass() == "bldg_gate"	||
				ent:GetClass() == "bldg_wall"	 then
				ent:UpdateControl()
			end
		end
	end
	if self and self:IsValid() then
		local ent = self
		local function RemoveEntity( ent )
 			if (ent and ent:IsValid()) then
 				ent:Remove()
 			end
 		end
 		timer.Simple( 1, RemoveEntity, ent )
		ent:Extinguish()
	 	ent:SetNotSolid( true )
 		ent:SetMoveType( MOVETYPE_NONE )
	 	ent:SetNoDraw( true )
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
