module( "territory", package.seeall )


local mBeam = Material( "effects/laser_tracer" )
local mSprite = Material( "sprites/grip" )
local points = {}
local terrs = {}
local areas = {}

local expandRate = 15

local mt = {}
local methods = {}
mt.__index = methods

AccessorFunc( methods, "parent", "Parent" )
AccessorFunc( methods, "targetdis", "TargetDistance" )
AccessorFunc( methods, "lerptime", "LerpTime" )
AccessorFunc( methods, "lerptimeend", "LerpTimeEnd" )
AccessorFunc( methods, "pos", "Pos" )
AccessorFunc( methods, "active", "Active" )

local default = {}
setmetatable( default, mt )
default.fake = true

local function CreateMarker( parent, id, ext, pos )
	
	local marker = {}
	setmetatable( marker, mt )
	
	marker:SetParent( parent )
	marker:SetPos( pos or parent:GetPos() )
	marker:SetActive( true )
	marker:SetTargetDistance( parent.TRad )
	marker.draw = {}
	marker.member = default
	marker.leader = default
	marker.center = parent:GetPos()
	marker.normal = parent:GetUp()
	marker.dis = 0
	marker.rad = (id * (360/(parent.TCount))) * math.pi/180
	marker.radx = math.cos(marker.rad)
	marker.rady = math.sin(marker.rad)
	marker.dir = Vector( marker.radx, marker.rady, 0 ):Normalize()
	marker.pid = id
	marker.ext = ext
	marker.aid = marker:GetAID()
	marker.begin = CurTime() + marker.rad
	
	points[ marker.aid ] = marker
	
	parent.VRad = parent.VRad or 0
	parent.TMarkers[ext] = parent.TMarkers[ext] or {}
	parent.TMarkers[ext][id] = marker
	
	return marker
	
end

function Create( type, parent, id )
	
	if !type then return nil end
	if !parent then return nil end
	
	if type == "marker" then
		
		return CreateMarker( parent, id, 0 )
		
	elseif type == "area" then
		
		local area = {}
		area.parent = parent
		area.radius = id
		return area
		
	end
	
end

hook.Add( "OnTerritoryCreated", "territory.OnTerritoryCreated", function( ent )
	if (ValidEntity(ent)) then
		if (ent.TRad) then
			local pos, gridsize = ent:GetPos(), ent.TRad2
			local mins = Vector( pos.x - gridsize, pos.y - gridsize, pos.z - gridsize )
			local maxs = Vector( pos.x + gridsize, pos.y + gridsize, pos.z + gridsize )
			for k, v in pairs( terrs ) do
				if (ValidEntity( v ) and v:GetOwner() == ent:GetOwner() and v != ent) then
					local vpos = v:GetPos()
					if (	( vpos.x > mins.x and vpos.x < maxs.x )	&&
						( vpos.y > mins.y and vpos.y < maxs.y )	&&
						( vpos.z > mins.z and vpos.z < maxs.z )	) then
						if ( pos:Distance( vpos ) <= math.Min( ent.TRad2, v.TRad2 ) ) then
							local trace = {}
							trace.start = pos + Vector( 0, 0, 72 )
							trace.endpos = vpos + Vector( 0, 0, 72 )
							trace.mask = MASK_SOLID_BRUSHONLY
							trace = util.TraceLine( trace )
							if !trace.HitWorld then
								v.candidates = v.candidates or {}
								v.candidates[ ent:EntIndex() ] = ent
								ent.candidates = ent.candidates or {}
								ent.candidates[ v:EntIndex() ] = v
							end
						end
					end
				end
			end
			terrs[ ent:EntIndex() ] = ent
		end
	end
end )

hook.Add( "OnTerritoryRemoved", "territory.OnTerritoryRemoved", function( ent )
	if (ValidEntity(ent)) then
		if (ent.TRad) then
			local entid = ent:EntIndex()
			for k, v in pairs( terrs ) do
				if ( v.candidates && v.candidates[ entid ] ) then
					v.candidates[ entid ] = nil
					if ( v.TMarkers ) then
						for _, ext in pairs( v.TMarkers ) do
							for _, p in pairs( ext ) do
								p:NarrowPhase()
							end
						end
					end
				end
			end
			terrs[ entid ] = nil
		end
	end
end )

function methods:NarrowPhase()
	
	self.nextNarrowPhase = self.nextNarrowPhase or CurTime()
	if (CurTime() < self.nextNarrowPhase) then return end
	self.nextNarrowPhase = CurTime() + 0.5
	
	local pos = self.draw.pos or self:GetPos()
	for k, v in pairs( self.parent.candidates ) do
		if (ValidEntity( v )) then
			if (pos:Distance(v:GetPos())<=(v.VRad or 0)) then
				self:SetActive( false )
				return
			end
		end
	end
	self:SetActive( true )
	
end

function methods:Remove()
	
	points[ self.aid ] = nil
	if ValidEntity( self.parent ) and self.parent.TMarkers then
		self.parent.TMarkers[self.pid] = nil
	end
	self = nil
	
end

function methods:GetAID()
	
	return tostring( self.parent:EntIndex() ).."-"..tostring( self.pid ).."-"..tostring( self.ext )
	
end

function methods:Think()
	
	self:Update()
	
end

local function intersectRayPlane( S1, S2, P, N ) --( startpoint, endpoinst, point on plane, plane's normal )
	
	local u = S2 - S1
	local w = S1 - P
	
	local d = N:Dot( u )
	local n = N:Dot( w )*-1
	
	if (math.abs( d ) < 0) then
		ErrorNoHalt( "parralel! WTF\n" )
		if (n == 0) then return end	--segment is in the plane
		return				--no intersection
	end
	
	local sI = n/d
	if (sI < 0 || sI > 1) then return end	--no intersection
	return S1 + sI * u
	
end

local function intersectRaySphere( RayPos, RayNormal, SpherePos, SphereRadius2)
	local oc = SpherePos - RayPos
	local l2oc = oc:Dot(oc)
	if (l2oc < SphereRadius2) then	// starts inside of the sphere
		local tca = oc:Dot(RayNormal) / RayNormal:Dot(RayNormal)
		local l2hc = (SphereRadius2 - l2oc) / RayNormal:Dot(RayNormal) + tca*tca	// division
		return tca + math.sqrt(l2hc)
	else return false end	// we only care if the ray starts inside the sphere!
end

local function calcSlide( vel, normal )
	local perp = vel:Angle():Right()
	return normal:Cross( perp ):Normalize()
end

local function traceForWater( trace, tr )
	trace = table.Copy( trace )
	trace.mask = MASK_WATERWORLD
	trace = util.TraceLine( trace )
	return trace.Fraction < tr.Fraction and trace
end

function methods:GetNextPos()
	
	if (!self.begin) then return end
	if (CurTime() < self.begin) then return end
	
	if (self.complete) then
		self.blocked = true
		return
	end
	
	local dir = self.dir:Cross( self.normal ):Normalize()
	local dis = intersectRaySphere( self:GetPos(), dir, self.center, self.parent.TRad2 )
	if !(dis and dis > 1) then
		self.complete = true
		return
	end
	
	self.vel = dir*dis
	
	local trace, tr, water = {}, {}
	
	trace.start = self:GetPos()+self.normal
	trace.endpos = trace.start + self.vel
	trace.mask = MASK_NPCSOLID_BRUSHONLY
	tr = util.TraceLine( trace )
	water = traceForWater( trace, tr )
	
	//debugoverlay.Line( tr.StartPos, tr.HitPos, 100 )
	
	if (water) then				--Find the edge of the water
		
		//debugoverlay.Line( water.StartPos, water.HitPos, 100, Color( 34, 34, 150, 255 ) )
		
		trace.start = water.HitPos
		trace.endpos = trace.start + self.dir:Cross( water.HitNormal ):Normalize() * -dis
		tr = util.TraceLine( trace )
		if (tr.HitWorld) then
			self.normal = tr.HitNormal
			self.draw.startPos = self:GetPos()
			self.draw.targetPos = tr.HitPos + tr.HitNormal
			self:SetLerpTime( self.draw.targetPos:Distance(self.draw.startPos)/expandRate )
			self:SetLerpTimeEnd( RealTime() + self:GetLerpTime() )
		end
		
		self.complete = true
		
	elseif (tr.Hit && tr.Fraction < 1) then	--Concave intersection
		
		self.normal = tr.HitNormal
		self.draw.startPos = self:GetPos()
		self.draw.targetPos = tr.HitPos + tr.HitNormal
		
		self:SetLerpTime( dis*tr.Fraction/expandRate )
		self:SetLerpTimeEnd( RealTime() + self:GetLerpTime() )
		
	else					--Check for Convex
		
		self.draw.startPos = self:GetPos()
		self.draw.targetPos = tr.HitPos + tr.HitNormal
		
		self:SetLerpTime( dis*tr.Fraction/expandRate )
		self:SetLerpTimeEnd( RealTime() + self:GetLerpTime() )
		
		local miss = table.Copy( tr )
		trace.start = tr.HitPos+self.normal
		trace.endpos = trace.start+self.normal*-4
		tr = util.TraceLine( trace )
		
		//debugoverlay.Line( tr.StartPos, tr.HitPos, 100 )
		
		if (tr.Hit) then		--Not convex, reached edge
			
			self.draw.targetPos = tr.HitPos + tr.HitNormal
			self.normal = tr.HitNormal
			self.complete = true
			
		else				--Find Convex Normal
			
			trace.start = tr.HitPos
			trace.endpos = trace.start - self.vel - self.normal
			tr = util.TraceLine( trace )
			
			//debugoverlay.Line( tr.StartPos, tr.HitPos, 100 )
			
			if (tr.Hit) then	--Found! Calculate the Segment Plane Intersection
				
				self.draw.targetPos = intersectRayPlane( miss.StartPos, miss.HitPos, tr.HitPos + tr.HitNormal, tr.HitNormal*-1 ) or tr.HitPos + tr.HitNormal
				if self.normal:Dot(Vector(0,0,1)) == 0 and tr.HitNormal:Cross( self.dir ):Dot(Vector(0,0,1))>0.5 then
					self.complete = true
				else
					self.normal = tr.HitNormal
				end
				
				self:SetLerpTime( self:GetPos():Distance( self.draw.targetPos )/expandRate )
				self:SetLerpTimeEnd( RealTime() + self:GetLerpTime() )
				self:SetPos( self.draw.targetPos )
				
				if self.normal:Dot(Vector( 0, 0, 1 )) == 0 then
					self.complete = true
					return
				end
				
			else
				
				self.complete = true
				
			end
			
		end
		
	end
	
	if self.normal:Dot(Vector( 0, 0, 1 )) <= 0 and self.complete then
		self.draw.targetPos = self:GetPos()
		self.complete = true
	end
	
	if !ConfirmBoundary( self.draw.targetPos ) then
		self.draw.targetPos = self:GetPos()
		self.complete = true
	end
	
	self:SetPos( self.draw.targetPos )
	
end

function methods:Update()
	
	if !ValidEntity(self.parent) then
		self:Remove()
		return
	end
	
	if self.member.fake || self.leader.fake then
		
		self:UpdateMembers()
		
	end
	
	local next = self:UpdateDraw()
	if !self.blocked then
		self:NarrowPhase()
		if next then
			self:GetNextPos()
		end
	end
	
end

function methods:UpdateMembers()
	
	local member = self:GetParent().TMarkers[self.ext][ self.pid-1 == 0 and self:GetParent().TCount or self.pid-1 ]
	if member and member.member != self then
		self.member = member
	end
	local leader = self:GetParent().TMarkers[self.ext][ self.pid+1 == self:GetParent().TCount+1 and 1 or self.pid+1 ]
	if leader and leader.leader != self then
		self.leader = leader
	end
	
end

function methods:UpdateDraw()
	
	self.draw = self.draw or {}
	
	if !(self:GetLerpTimeEnd() and self:GetLerpTime() and self.draw.targetPos) then return true end
	
	local lerp = 1
	
	if !(self.blocked) then
		
		lerp = math.Clamp( 1 - ( self:GetLerpTimeEnd()-RealTime() ) / self:GetLerpTime(), 0, 1 )
		self.draw.pos = self.draw.startPos + (self.draw.targetPos-self.draw.startPos)*lerp
		
		self.dis = self.draw.pos:Distance( self.center )
		if ( self.dis > self.parent.VRad ) then
			self.parent.VRad =  self.dis
			for k, v in pairs( self.parent.candidates ) do
				if ( v.TMarkers ) then
					for _, ext in pairs( v.TMarkers ) do
						for _, p in pairs( ext ) do
							p:NarrowPhase()
						end
					end
				end
			end
		end
		
	end
	
	if !(self.blocked  && self.member.blocked && self.leader.blocked) then
		
		self.draw.dir = (self.draw.dir and self.member.draw.pos and self.leader.draw.pos) and
				(((self.draw.pos-self.member.draw.pos)+(self.leader.draw.pos-self.draw.pos))*0.5):Normalize() or
				self.dir
		
		self.draw.beam1 = self.draw.pos + (self.draw.dir or self.dir)*-2
		self.draw.beam2 = self.draw.pos + (self.draw.dir or self.dir)*2
		
	end
	
	return lerp == 1
	
end

function methods:Draw()
	
	if !(self.member) then return end
	if !(self.draw and self.draw.pos and self.draw.beam1 and self.draw.beam2) then return end
	if !((self:GetActive() and self.member:GetActive()) || (self:GetActive() and self.leader:GetActive())) then return end
	
	self.color.a = 255
	
	render.SetMaterial( mBeam )
	render.DrawBeam(	self.draw.beam1,
				self.draw.beam2,
				3, 0.25, 0.75,
				self.color
		)
	
end