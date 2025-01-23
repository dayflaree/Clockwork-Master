/*-------------------------------------------------------------------------------------------------------------------------
	Rigid rope
-------------------------------------------------------------------------------------------------------------------------*/

include( "shared.lua" )

local function hermiteInterpolate( y1, y2, y3, y4, tension, bias, mu )
	local m0, m1, mu2, mu3
	local a0, a1, a2, a3
	
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

function ENT:Draw()
	if ( !self:GetDTEntity( 0 ):IsValid() or !self:GetDTEntity( 1 ):IsValid() ) then return end
	if ( !self.Plug1 ) then
		self.Plug1 = self:GetDTEntity( 0 )
		self.Plug2 = self:GetDTEntity( 1 )
	end
	if ( !self.CableMaterial ) then self.CableMaterial = Material( "cable/cable2" ) end
	
	local p1f = self.Plug1:GetAngles():Forward()
	local p2f = self.Plug2:GetAngles():Forward()
	
	local p1 = self.Plug1:GetPos() + p1f * 12
	local p2 = self.Plug2:GetPos() + p2f * 12
	
	render.SetMaterial( self.CableMaterial )
	
	local resolution = 0.1	
	for mu = 0, 1 - resolution, resolution do
		render.DrawBeam(
			Vector( ( p2.x - p1.x ) * mu + p1.x, hermiteInterpolate( p2.y - p1f.y * 100, p1.y, p2.y, p1.y - p2f.y * 100, 0, 0, mu ), hermiteInterpolate( p2.z - p1f.z * 100, p1.z, p2.z, p1.z - p2f.z * 100, 0, 0, mu ) ),
			Vector( ( p2.x - p1.x ) * ( mu + resolution ) + p1.x, hermiteInterpolate( p2.y - p1f.y * 100, p1.y, p2.y, p1.y - p2f.y * 100, 0, 0, mu + resolution ), hermiteInterpolate( p2.z - p1f.z * 100, p1.z, p2.z, p1.z - p2f.z * 100, 0, 0, mu + resolution ) ),
			1.3, 0, 0, color_white
		)
	end
end