local material = Material( "models/debug/debugwhite" )

local function getStartPosition( p, d, angle, radius )
	local ang = d:Angle():Right():Angle()
	ang:RotateAroundAxis( d, 180 - angle )
	return p + ang:Forward() * radius
end

local function getEndPosition( p, d, angle, radius )
	local ang = d:Angle():Right():Angle()
	ang:RotateAroundAxis( d, angle )
	return p + ang:Forward() * radius
end

local function drawCylinder( p1, d1, p2, d2, radius, segments )
	local segments = segments or 10
	local angle = 360 / segments
	local ang
	
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

hook.Add( "PostDrawOpaqueRenderables", "CylinderTest", function()
	local p1 = Vector( 0, 0, 0 )	
	local p2 = Vector( 0, 100, 50 )
	local d1 = Vector( 0, -1, 0 )
	local d2 = Vector( 0, 1, 0 )
	local r = 0.8
	
	render.SetMaterial( material )
	
	drawCylinder( p1, d1, p2, d2, r )
end )