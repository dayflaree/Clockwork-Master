AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


util.PrecacheModel( "models/jaanus/gate.mdl" );


function ENT:Initialize()
	
	//the gate
	self.index = self.index or 1
	self:SetModel( "models/jaanus/gate.mdl" )
	
	local vec1, vec2 = Vector( -6, -20, 0 ), Vector( 6, 20, 30 )
	self:PhysicsInitBox( vec1, vec2 )
	self:SetCollisionBounds( vec1, vec2 )
	self:SetSolid( SOLID_BBOX )
	self:SetMoveCollide( MOVECOLLIDE_FLY_SLIDE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Sleep()
	end

	//Character
	self.maxhealth = BUILDINGS[self.index].health
	self.health = self.maxhealth
	self.clamp = 0

	self.state = "closed"
	self.nextToggle = CurTime()
	self.touching = {}

	self:SetAngles(self.ang)

end

function ENT:Think()
	if self.state == "close" then
		self:Close()
	elseif self.state == "open" then
		self:Open()
	end
	if self.Overlord and !(ValidEntity(self.Overlord) and self.Overlord:IsPlayer()) then
		self:Raze()
	end
end

function ENT:Open()
	if CurTime() < self.nextToggle then return false end
	self.nextToggle = CurTime() + 1
	self:SetNotSolid(true)
	self:SetTrigger(true)
	self:SetAnim( "lower" )
	self.state = "opened"
	self:EmitSound("buttons/lever4.wav")
end

function ENT:Close()
	if CurTime() < self.nextToggle then return false end
	self.nextToggle = CurTime() + 1
	if !ValidEntity( self.Overlord ) then return end
	for _, ent in pairs( ents.FindInSphere(self:GetPos(),10) ) do
		if ValidEntity(ent) and ent:IsUnit() and ValidEntity( ent.Overlord ) and (ent.Overlord == self.Overlord || self.Overlord:GetNWBool("Ally "..ent.Overlord:UserID())) then
			return
		end
	end
	self:SetNotSolid(false)
	self:SetTrigger(false)
	self:SetAnim( "raise" )
	self.state = "closed"
	self:EmitSound("buttons/lever6.wav")
end

function ENT:StartTouch( ent )
	if !(ent.Overlord and ent:IsUnit()) then return end
	if !ValidEntity( self.Overlord ) then
		self.touching[ent] = true
		self.touched = true
		self.state = "open"
	elseif ValidEntity( ent ) and ent:IsUnit() and (ent.Overlord == self.Overlord || self.Overlord:GetNWBool("Ally "..ent.Overlord:UserID())==true) then
		self.touching[ent] = true
		self.touched = true
		self.state = "open"
	end
end

function ENT:EndTouch( ent )
	if !(ValidEntity(self.Overlord) and ValidEntity( ent.Overlord )) then
		self.touching[ent] = nil
	elseif ValidEntity( ent ) and ent:IsUnit() and (ent.Overlord == self.Overlord || self.Overlord:GetNWBool("Ally "..ent.Overlord:UserID())==true) then
		self.touching[ent] = nil
	end
	if self.touched and table.getn( self.touching ) == 0 then
		self:EndTouchAll()
	end
end

function ENT:EndTouchAll( ent )
	self.touching = {}
	self.touched = false
	self.state = "close"
end

function ENT:UpdateControl()
	if !self or !self.Entity or !self.Entity:IsValid() then return end
	if self:IsDead() then return end
	if !self.Overlord then
		local ents = ents.FindInSphere( self.Entity:GetPos(), 130 )
		if #ents <=0 then return end
		for _, ent in pairs( ents ) do
			if (ent:GetClass() == "bldg_city" || ent:GetClass() == "bldg_residence") and ent:IsReady() and ent:GetOverlord() then
				self:SetControl( ent:GetOverlord() )
				break
			end
		end
	else
		local ents = ents.FindInSphere( self.Entity:GetPos(), 128 )
		local cities = {}
		for _, ent in pairs( ents ) do
			if (ent:GetClass() == "bldg_city" || ent:GetClass() == "bldg_residence") and !ent:IsDead() and ent:GetOverlord() == self.Overlord then
				table.insert( cities, ent )
			end
		end
		if #cities <= 0 then
			self:RemoveControl()
		end
	end
end

function ENT:SetControl( overlord )
	if !overlord or !overlord:IsPlayer() then return end
	self.Overlord = overlord
	self.Overlord:SetNWInt("_fences", self.Overlord:GetNWInt("_fences") + 1)
	local r,g,b,a = self:GetOverlord():GetColor()
	self:GetClamp( r, g, b )
	local d = self.clamp - ( self.clamp * math.Clamp( self.health , 0 , self.maxhealth ) / self.maxhealth )
	r = r + d
	g = g + d
	b = b + d
	self.Entity:SetColor( r,g,b,a )
end

function ENT:RemoveControl()
	self.Entity:SetColor( 250, 250, 250, 255 )
	if !self.Overlord then return end
	if self.Overlord:IsPlayer() then
		self.Overlord:SetNWInt("_fences", self.Overlord:GetNWInt("_fences") - 1)
	end
	self.Overlord = nil
	self:UpdateControl()
end

function ENT:SetSpawner(pl)
	self.SpawnedBy = pl
	if !self.claimed then
	if pl == self.SpawnedBy then
		self.Entity:SetColor( pl:GetColor() )
		self.claimed = true
		self.Overlord = pl
		self.Overlord:SetNWInt("_gates", self.Overlord:GetNWInt("_gates") + 1)
		self:SetOwner( pl )
		local r,g,b,a = pl:GetColor()
		self:GetClamp( r, g, b )
	end
	end
end

function ENT:Raze( info, inflictor )
	info = info or "death"
	if self:IsDead() then return end
	if self.Overlord and !self.Spawning and info ~= "cleanup" then
		self.Overlord:SetNWInt("_gates", self.Overlord:GetNWInt("_gates") - 1)
	end
	self.Dead = true
	self:SetNWBool("dead", true)
	if inflictor and inflictor:IsPlayer() and !self.Spawning then
		inflictor:SetNWInt("_gold", inflictor:GetNWInt("_gold")+8)
		inflictor.killcashbonus = inflictor.killcashbonus + 8
	end
	if ValidEntity( self ) then
		local ent = self.Entity
		ent:Extinguish()
		if info == "death" then
			local effectdata = EffectData()
				effectdata:SetEntity( self )
				effectdata:SetOrigin( self:GetPos() )
				effectdata:SetRadius( self:OBBMaxs().z*0.5 )
				effectdata:SetScale( 10 )
				effectdata:SetMagnitude( GIB_STONE )
			util.Effect( "gib_structure", effectdata )
		end
		if string.find( info, "refund" ) then
			local effectdata = EffectData()
				effectdata:SetEntity( self )
			util.Effect( "dissolve", effectdata, true, true )
		end
		local function RemoveEntity( ent )
 			if (ent and ent:IsValid()) then
 				ent:Remove()
 			end
 		end
 		timer.Simple( 1, RemoveEntity, ent )
	 	ent:SetNotSolid( true )
 		ent:SetMoveType( MOVETYPE_NONE )
	 	ent:SetNoDraw( true )
	end
	self.Entity:EmitSound( "sassilization/units/buildingbreak0"..math.random(1,2)..".wav" )
end
