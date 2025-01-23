AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheModel( "models/jaanus/workshop_down.mdl" );
util.PrecacheModel( "models/jaanus/workshop.mdl" );

function ENT:Initialize()
	
	//the workshop
	self.index = self.index or 1
	self:SetModel( "models/jaanus/workshop_down.mdl" )
	self:PhysicsInitBox( self:OBBMins(), self:OBBMaxs() )
	self:SetCollisionBounds( self:OBBMins(), self:OBBMaxs() )
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
	self.upgraded = false

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
		self.Spawning = false
		self:SetNWBool("spawning",false)
		self.Dead = false
		local effectdata = EffectData()
			effectdata:SetEntity( self )
		util.Effect( "materialize", effectdata, 1, 1 )
		self.Overlord:SetNWInt("_workshops", self.Overlord:GetNWInt("_workshops") + 1) //add to the count
		self.Overlord:SendLua("playsound('sassilization/workshopComplete.wav', -1)")
	end
	if self.Dead and !self.Spawning then return end
	if self:WaterLevel() > 0 then self:Raze() end
	if !self:GetOverlord() then self:Raze() end
	
end

function ENT:Upgrade()
	if self.Dead then return end
	if self.upgraded then return end
	local food = BUILDINGS[self.index].food
	local iron = BUILDINGS[self.index].iron
	local gold = BUILDINGS[self.index].gold
	self:SetModel( "models/jaanus/workshop.mdl" )
	self.maxhealth = self.maxhealth * 1.5
	self.health = self.maxhealth
	self.Overlord:SetNWInt("_workshops", self.Overlord:GetNWInt("_workshops") + 99)
	self.Overlord:DeductResource("_food", food)
	self.Overlord:DeductResource("_iron", iron)
	self.Overlord:DeductResource("_gold", gold, true)
	self.upgraded = true
	return
end

function ENT:Raze( info, inflictor )
	if self.Dead and self:IsReady() then return end
	self.Spawning = false
	self:SetNWBool("spawning", false)
	self.Dead = true
	self:SetNWBool("dead", true)
	if ValidEntity( self.Overlord ) and !self.Spawning and info ~= "cleanup" then
		if self.upgraded then self.Overlord:SetNWInt("_workshops", self.Overlord:GetNWInt("_workshops") - 100)
		else self.Overlord:SetNWInt("_workshops", self.Overlord:GetNWInt("_workshops") - 1) end
		if self.Overlord:GetNWInt("_gold") > 30 then
			self.Overlord:SetNWInt( "_gold", self.Overlord:GetNWInt("_gold") - 30)
			self.Overlord:SetFrags( self.Overlord:GetNWInt("_gold") )
		end
	end
	self.Spawning = false
	if inflictor and inflictor:IsPlayer() and !self.Spawning then
		inflictor:SetNWInt("_gold", inflictor:GetNWInt("_gold")+38)
		inflictor.killcashbonus = inflictor.killcashbonus + 8
	end
	if self and self:IsValid() then
		local ent = self
		if info == "death" then
			local effectdata = EffectData()
				effectdata:SetEntity( self )
				effectdata:SetOrigin( self:GetPos() )
				effectdata:SetRadius( self:OBBMaxs().z*0.5 )
				effectdata:SetScale( 10 )
				effectdata:SetMagnitude( GIB_ALL )
			util.Effect( "gib_structure", effectdata )
		end
		local ent = self
		local function RemoveEntity( ent )
 			if (ent and ent:IsValid()) then
 				ent:Remove()
 			end
 		end
 		timer.Simple( .1, RemoveEntity, ent )
		ent:Extinguish()
	 	ent:SetNotSolid( true )
 		ent:SetMoveType( MOVETYPE_NONE )
	 	ent:SetNoDraw( true )
	end
	self:EmitSound( "sassilization/units/buildingbreak0"..math.random(1,2)..".wav" )
end