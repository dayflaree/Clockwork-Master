include('shared.lua')

function ENT:Initialize()
	
	if !self.TRad then return end
	if !ValidEntity( self:GetOwner() ) then return end
	self.TRad2 = self.TRad * self.TRad
	self.TCount = math.Round( self.TRad * 0.4 )
	self.candidates = {}
	hook.Call( "OnTerritoryCreated", GAMEMODE, self )
	
	self.Spawntime = CurTime() + 1
	
end

function ENT:Think()
	
	if !self.TMarkers then return end
	
	self.Entity:SetRenderBounds( Vector()*self.TRad*-1, Vector()*self.TRad )
	
	for _, extension in pairs( self.TMarkers ) do
		for _, marker in pairs( extension ) do
			marker:Think()
		end
	end
	
end

function ENT:Draw()
	
	local distance = self.Entity:GetPos():Distance( LocalPlayer():GetPos() )
	local color = Color( self:GetColor() )
	local pl = LocalPlayer()
	if distance < 1000 then
		
		if self.TMarkers then
			if self:GetOwner() != pl then
				for _, e in pairs( self.TMarkers ) do
					for _, p in pairs( e ) do
						p:Remove()
					end
				end
				self.TMarkers = nil
				return
			end
			for _, extension in pairs( self.TMarkers ) do
				for _, marker in pairs( extension ) do
					marker.color = Color( self:GetOwner():GetColor() )
					marker:Draw()
				end
			end
		elseif self.TCount and CurTime() > self.Spawntime and color.a == 255 and self:GetOwner() == pl then
			self.Spawntime = 0
			self.TMarkers = {}
			for i=1,self.TCount do
				local tr = {}
				tr.start = self.Entity:GetPos() + self.Entity:OBBCenter()
				tr.endpos = tr.start + self.Entity:GetUp() * -2
				tr.mask = MASK_SOLID_BRUSHONLY
				tr = util.TraceLine( tr )
				local marker = territory.Create( "marker", self, i, tr.HitPos )
				marker.color = Color( self:GetOwner():GetColor() )
			end
		end
		
		self.Entity:DrawModel()
		
	else return end
	
end

function ENT:OnRemove()
	if (self.TRad) then
		hook.Call( "OnTerritoryRemoved", GAMEMODE, self )
	end
end