EFFECT.Mat = Material( "trails/laser"  )

local function distance( x, y )
	return math.sqrt(x*x + y*y)
end

function EFFECT:Init( data )

	self.TargetEnt = data:GetEntity()

	if self.TargetEnt == NULL then return end

	self.OwnerID = math.Round(data:GetScale())
	
	local mins = self.TargetEnt:OBBMins()
	local maxs = self.TargetEnt:OBBMaxs()
	
	self.Radius = (distance( mins.x, mins.y )+distance( mins.x, maxs.y )+distance( maxs.x, mins.y )+distance( maxs.x, maxs.y ))*0.25*0.8

	self.originalRadius = self.Radius

	self.Amplitude = 1				-- raise this, or lower it, to set how fast the circle 'pulses'
	self.Width = 6					-- How wide the beam is
	self.PulseSizeMod = 0.10			-- how big the pulse is in relation to the radius
	self.StartPos = self.TargetEnt:GetPos() + Vector( 0, 0, self.Width*0.5 )

	self.Entity:SetRenderBoundsWS( self.StartPos-Vector(self.Radius,self.Radius,self.Radius), self.StartPos+Vector(self.Radius,self.Radius,self.Radius))
	
	self.TracerTime = 1.5
	self.Length = math.Rand( 0.1, 0.15 )
	
	self.DieTime = CurTime() + self.TracerTime

	self.setup = true

end


function EFFECT:Think( )

	if !self.setup then return true end

	if self.TargetEnt == NULL then return false end
	return CurTime() < self.DieTime

end

function EFFECT:Render( )

	if self.OwnerID != LocalPlayer():UserID() then return false end

	local fDelta = (self.DieTime - CurTime()) / self.TracerTime
			
	render.SetMaterial( self.Mat )
	
	self.Radius = math.sin( math.rad(360 * self.Amplitude * fDelta) ) * self.originalRadius * self.PulseSizeMod + self.originalRadius
	
	render.StartBeam( 17 )
	
	local x,y
	for i = 0,16 do
		x = math.sin( math.rad( i*22.5 ) ) * self.Radius
		y = math.cos( math.rad( i*22.5 ) ) * self.Radius
		render.AddBeam( self.StartPos + Vector(x,y,0), self.Width, CurTime()+1,  Color(255, 0, 0, math.Min(255,255 * fDelta*3)) )
	end
	render.EndBeam()

end