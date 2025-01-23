AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheModel( "models/jaanus/ironmine.mdl" );

function ENT:Initialize()
	
	self:SetModel( "models/jaanus/ironmine.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_PUSH )
	self:SetColor( 255,255, 255,255 )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	
	local vStart = self:GetPos()

	local trace = {}
	trace.start = vStart
	trace.endpos = vStart + Vector( 0, 0, -320 )
	trace.mask = MASK_SOLID_BRUSHONLY
	trace.filter = self

	local tr = util.TraceLine( trace )

	if tr.HitWorld then
		self:SetPos( tr.HitPos + tr.HitNormal * 0.5 )
		local ang = tr.HitNormal:Angle()
		ang.p = ang.p + 90
		if tr.HitNormal == Vector( 0, 0, 1 ) then
			ang.y = math.random( 0, 360 )
		end
		self:SetAngles( ang )
	end
	
	self.Overlord = false
	self.attachment = false
	
	self:UpdateControl()

end

function ENT:UpdateControl()
	if !self:GetOverlord() then
		local ents = ents.FindInSphere( self:GetPos(), 40 )
		if #ents <=0 then return end
		for _, ent in pairs( ents ) do
			if (ent:GetClass() == "bldg_city" || ent:GetClass() == "bldg_residence") and !ent:IsDead() and ent:GetOverlord() then
				self:SetControl( ent:GetOverlord() )
				break
			end
		end
	else
		local ents = ents.FindInSphere( self:GetPos(), 40 )
		local cities = {}
		for _, ent in pairs( ents ) do	
			if (ent:GetClass() == "bldg_city" || ent:GetClass() == "bldg_residence") and !ent:IsDead() and ent:GetOverlord() == self:GetOverlord() then
				table.insert( cities, ent )
			end
		end
		if #cities <= 0 then
			self:RemoveControl()
		end
	end
	return true
end

function ENT:GetOverlord()
	return self.Overlord
end

function ENT:SetControl( overlord )
	self.Overlord = overlord
	if !self.Overlord or !self.Overlord:IsPlayer() then return end
	self.Overlord:SetNWInt("_mines", self.Overlord:GetNWInt("_mines") + 1)
	if !self.attachment then
		local attch = ents.Create( "prop_physics" )
		attch:SetModel( "models/jaanus/ironmine_shack.mdl" )
		attch:SetPos( self:GetPos() + (self:GetRight() * math.random( 0, 4 )) + (self:GetUp() * -1) )
		attch:SetAngles( Angle( self:GetAngles().p, math.random( 0, 360 ), self:GetAngles().r ) )
		attch:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		attch:Spawn()
		attch:Activate()
		attch:GetPhysicsObject():EnableMotion(false)
		attch:SetColor( overlord:GetColor() )
		self.attachment = attch
	end
end

function ENT:RemoveControl()
	self:SetColor( 255, 255, 255, 255 )
	if ValidEntity( self.Overlord ) and self.Overlord:IsPlayer() then
		self.Overlord:SetNWInt("_mines", self.Overlord:GetNWInt("_mines") - 1)
	end
	self.Overlord = nil
	if ValidEntity( self.attachment ) then
		self.attachment:Remove()
		self.attachment = nil
	end
	self:UpdateControl()
end