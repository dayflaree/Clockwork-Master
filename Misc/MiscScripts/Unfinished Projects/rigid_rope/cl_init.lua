/*-------------------------------------------------------------------------------------------------------------------------
	Rigid rope
-------------------------------------------------------------------------------------------------------------------------*/

include( "shared.lua" )

local ang
local function getStartPosition( p, d, angle, radius )
	ang = d:Angle():Right():Angle()
	ang:RotateAroundAxis( d, angle )
	return p + ang:Forward() * radius
end

local ang
local function getEndPosition( p, d, angle, radius )
	ang = d:Angle():Right():Angle()
	ang:RotateAroundAxis( d, angle )
	return p + ang:Forward() * radius
end

local angle, ang
local function drawCylinder( p1, d1, p2, d2, radius, segments )
	segments = segments or 10
	angle = 360 / segments
	
	mesh.Begin( MATERIAL_QUADS, segments * 2 )		
		for i = 0, segments - 1 do
			ang = i * angle
			
			-- Inside
			mesh.Position( getStartPosition( p1, d1, ang, radius ) )
			mesh.Normal( Vector( 0, 0, 1 ) )
			mesh.AdvanceVertex()
			
			mesh.Position( getStartPosition( p1, d1, ang + angle, radius ) )
			mesh.Normal( Vector( 0, 0, 1 ) )
			mesh.AdvanceVertex()
			
			mesh.Position( getEndPosition( p2, d2, ang + angle, radius ) )
			mesh.Normal( Vector( 0, 0, 1 ) )
			mesh.AdvanceVertex()
			
			mesh.Position( getEndPosition( p2, d2, ang, radius ) )
			mesh.Normal( Vector( 0, 0, 1 ) )
			mesh.AdvanceVertex()
			
			-- Outside				
			mesh.Position( getEndPosition( p2, d2, ang, radius ) )
			mesh.Normal( Vector( 0, 0, 1 ) )
			mesh.AdvanceVertex()
			
			mesh.Position( getEndPosition( p2, d2, ang + angle, radius ) )
			mesh.Normal( Vector( 0, 0, 1 ) )
			mesh.AdvanceVertex()
			
			mesh.Position( getStartPosition( p1, d1, ang + angle, radius ) )
			mesh.Normal( Vector( 0, 0, 1 ) )
			mesh.AdvanceVertex()
			
			mesh.Position( getStartPosition( p1, d1, ang, radius ) )
			mesh.Normal( Vector( 0, 0, 1 ) )
			mesh.AdvanceVertex()
		end
	mesh.End()
end

local m0, m1, mu2, mu3
local a0, a1, a2, a3
local function hermiteInterpolate( y1, y2, y3, y4, tension, bias, mu )	
	mu2 = mu * mu
	mu3 = mu2 * mu
	m0 = ( y2 - y1 ) * ( 1 + bias ) * ( 1 - tension ) / 2 + ( y3 - y2 ) * ( 1 - bias ) * ( 1 - tension ) / 2
	m1 = ( y3 - y2 ) * ( 1 + bias ) * ( 1 - tension ) / 2 + ( y4 - y3 ) * ( 1 - bias ) * ( 1 - tension ) / 2
	a0 = 2 * mu3 - 3 * mu2 + 1
	a1 = mu3 - 2 * mu2 + mu
	a2 = mu3 - mu2
	a3 = -2 * mu3 + 3 * mu2
	
	return a0 * y2 + a1 * m0 + a2 * m1 + a3 * y3
end

local p1, p2, p1f, p2f, startpos, endpos, endpos2
local resolution = 0.1
function ENT:Draw()
	if ( !self:GetDTEntity( 0 ):IsValid() or !self:GetDTEntity( 1 ):IsValid() ) then return end
	if ( !self.Plug1 ) then
		self.Plug1 = self:GetDTEntity( 0 )
		self.Plug2 = self:GetDTEntity( 1 )
	end
	if ( !self.Material ) then self.Material = Material( "models/debug/debugwhite" ) end
	
	p1f = self.Plug1:GetAngles():Forward()
	p2f = self.Plug2:GetAngles():Forward()
	
	p1 = self.Plug1:GetPos() + p1f * 11
	p2 = self.Plug2:GetPos() + p2f * 11
	
	render.SetMaterial( self.Material )
	
	for mu = 0, 1 - resolution, resolution do
		startpos =  Vector( ( p2.x - p1.x ) * mu + p1.x, hermiteInterpolate( p2.y - p1f.y * 100, p1.y, p2.y, p1.y - p2f.y * 100, 0, 0, mu ), hermiteInterpolate( p2.z - p1f.z * 100, p1.z, p2.z, p1.z - p2f.z * 100, 0, 0, mu ) )
		endpos = Vector( ( p2.x - p1.x ) * ( mu + resolution ) + p1.x, hermiteInterpolate( p2.y - p1f.y * 100, p1.y, p2.y, p1.y - p2f.y * 100, 0, 0, mu + resolution ), hermiteInterpolate( p2.z - p1f.z * 100, p1.z, p2.z, p1.z - p2f.z * 100, 0, 0, mu + resolution ) )
		
		if ( mu + resolution >= 1 ) then
			endpos2 = self.Plug2:GetPos() - p1f * 100
		else
			endpos2 = Vector( ( p2.x - p1.x ) * ( mu + resolution*2 ) + p1.x, hermiteInterpolate( p2.y - p1f.y * 100, p1.y, p2.y, p1.y - p2f.y * 100, 0, 0, mu + resolution*2 ), hermiteInterpolate( p2.z - p1f.z * 100, p1.z, p2.z, p1.z - p2f.z * 100, 0, 0, mu + resolution*2 ) )
		end
		
		drawCylinder( startpos, endpos - startpos, endpos, endpos2 - endpos, 1.3 )
	end
end