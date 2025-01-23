include('shared.lua')

local matRefract = Material( "models/spawn_effect" )
local matLight = Material( "models/spawn_effect2" )
local matIndicator = Material("sassilization/indicator")
local matCircle = Material("sassilization/circle")

local maxhealths = {}
maxhealths["unit_archer"]	= 9
maxhealths["unit_ballista"]	= 30
maxhealths["unit_catapult"]	= 35
maxhealths["unit_galleon"]	= 60
maxhealths["unit_horsie"]	= 80
maxhealths["unit_peasant"]	= 10
maxhealths["unit_scallywag"]	= 16
maxhealths["unit_swordsman"]	= 15

local upright = {"unit_archer","unit_peasant","unit_swordsman","unit_scallywag"}

function ENT:Initialize()
	
	local ang, size = self.Entity:GetAngles()
	
	if string.find(self.Entity:GetModel(), "models/Jaanus/galleon_") then
		size = 20
	end
	if self.Entity:GetModel() == "models/Jaanus/catapult.mdl" then
		size = 15
	end
	if self.Entity:GetModel() == "models/Jaanus/ballista.mdl" then
		size = 12
	end
	if self.Entity:GetModel() == "models/Jaanus/horsie.mdl" then
		size = 15
	end
	
	self.ang = ang or 0
	self.size = size or 5
	self.mhp = maxhealths[ self.Entity:GetClass() ] or 10
	self.upright = table.HasValue( upright, self.Entity:GetClass() )
	
	self.Entity:SetRenderBounds( Vector()*-105, Vector()*10 )
	
	self.AutomaticFrameAdvance = true
	
end

function ENT:Draw()
	
	if !UNITS then return end
	if !ValidEntity( self.Entity:GetOwner() ) then return end
	if self.Entity:GetPos():Distance( LocalPlayer():GetPos() ) > 500 then return end
	
	local owner, pos, eid, color = self.Entity:GetOwner(), self.Entity:GetPos(), self.Entity:EntIndex(), Color()
	
	self.oldpos = self.oldpos or pos
	self:SetAngles( self.upright and Angle( 0, self.ang.y, 0 ) or self.ang )
	
	local tr = {}
	tr.start = pos + Angle( 0, self.ang, 0 ):Forward()*-.5 + Vector( 0, 0, self.Entity:OBBMins().z+1 )
	tr.endpos = tr.start-Vector(0,0,self.size*3)
	tr.filter = self.Entity
	tr.mask = MASK_WATERWORLD
	local trace = util.TraceLine( tr )
	tr.endpos = tr.start-Vector(0,0,100)
	tr = util.TraceLine( tr )
	
	if pos:Distance( self.oldpos ) > 1.5 || ValidEntity( Entity( UNITS.targets[ eid ] ) ) then
		local newAng = (pos-self.oldpos):Angle()
		if UNITS.targets[ eid ] then
			local target = Entity( UNITS.targets[ eid ] )
			if ValidEntity( target ) then
				newAng = (target:GetPos()-pos):Angle()
			end
		end
		if trace.HitWorld and !self.upright then
			local ay = pos.y - self.oldpos.y
			local ax = pos.x - self.oldpos.x
			local rad = math.atan2( ay, ax )
			local dp = Vector( math.cos( rad ), math.sin( rad ), 0 ):DotProduct( trace.HitNormal ) * -1
			newAng.pitch = 360 - (( trace.HitNormal:Angle().p - 270 ) * dp * 2)
			local lift = dp * 200
			newAng.roll = trace.HitNormal:Angle().r
		end
		self.ang = LerpAngle( .5, self.ang, newAng )
		self.oldpos = pos
	end
	
	if tr.Fraction < 1 and tr.HitWorld then
		
		local alpha = (1-tr.Fraction)*255
		if UNITS.selected[ eid ] then
			color = Color( 255, 255, 255, alpha )
			render.SetMaterial( matIndicator )
			render.DrawQuadEasy( tr.HitPos+(tr.HitNormal * .6), tr.HitNormal, self.size*1.6, self.size*1.6, color )
		end
		
		UNITS.health[ eid ] = UNITS.health[ eid ] or self.mhp
		UNITS.colors[ eid ] = UNITS.colors[ eid ] or Color( self.Entity:GetOwner():GetColor() )
		
		local frac = math.Clamp( UNITS.health[ eid ] / self.mhp, 0, 1 )
		
		color = UNITS.colors[ eid ]
		color = Color(
				color.r - ( color.r * frac * 0.5 ),
				color.g - ( color.g * frac * 0.5 ),
				color.b - ( color.b * frac * 0.5 ),
				alpha
			)
		
		render.SetMaterial( matCircle )
		render.DrawQuadEasy( tr.HitPos+(tr.HitNormal * .5), tr.HitNormal, self.size, self.size, color )
		
	end
	
	if self:GetClass() != "unit_scallywag" and trace.HitWorld and !self.Entity:GetNWBool("gravitated") then
		self.Entity:SetPos( trace.HitPos + trace.HitNormal )
	end
	
	self.Entity:DrawModel()
	self.Entity:SetPos( pos )
	
end

function ENT:OnRemove()
	
	local eid = self:EntIndex()
	UNITS.selected[ eid ] = nil
	UNITS.colors[ eid ] = nil
	UNITS.health[ eid ] = nil
	
end