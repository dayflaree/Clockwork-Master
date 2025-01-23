/*
	Load an exported SketchUp model
*/

local s, l, e
local function getBetween( str, start, finish, offset )
	s, l = string.find( str, start, offset, true )
	if ( !s ) then return end
	s = s + #start
	e = string.find( str, finish, s, true ) or #str
	return string.sub( str, s, e-1 ), e
end

local function getBetweenAll( str, start, finish )
	local results = {}
	
	local res, offset = getBetween( str, start, finish )
	while ( res ) do
		table.insert( results, res )
		res, offset = getBetween( str, start, finish, offset )
	end
	
	return results
end

local n = tonumber
local function loadSketchUp( src, lightPos, scale )
	local vertices, normals, triangles = {}, {}, {}
	lightPos:Normalize()
	scale = scale or 1
	
	for _, meshData in pairs( getBetweenAll( src, "<mesh>", "</mesh>" ) ) do
		if ( !string.find( meshData, "<triangles" ) ) then continue end
		
		local vertexID = string.match( meshData, "<input%s+semantic=\"POSITION\"%s+source=\"#(ID[0-9]+)\"" )
		local normalID = string.match( meshData, "<input%s+semantic=\"NORMAL\"%s+source=\"#(ID[0-9]+)\"" )
		local verticesRaw = string.match( meshData, "<source id=\"" .. vertexID .. "\">%s+<[^>]+>(.+)</float_array>.+</source>" )
		local normalsRaw = string.match( meshData, "<source id=\"" .. normalID .. "\">%s+<[^>]+>(.+)</float_array>.+</source>" )
		
		for x, y, z in string.gmatch( verticesRaw, "([0-9.e-]+)%s+([0-9.e-]+)%s+([0-9.e-]+)" ) do
			table.insert( vertices, Vector( n(x), n(y), n(z) ) )
		end
		for x, y, z in string.gmatch( normalsRaw, "([0-9.e-]+)%s+([0-9.e-]+)%s+([0-9.e-]+)" ) do
			table.insert( normals, Vector( n(x), n(y), n(z) ) )
		end
		
		if ( #vertices >= #normals ) then
			local trianglesRaw = string.match( meshData, "<triangles.+<p>(.+)</p>%s+</triangles>" )
			local lx, ly, ang
			for p1, p2, p3 in string.gmatch( trianglesRaw, "([0-9]+)%s+([0-9]+)%s+([0-9]+)" ) do
				p1 = n(p1)
				p2 = n(p2)
				p3 = n(p3)
				
				local normal = ( vertices[p3+1] - vertices[p2+1] ):Cross( vertices[p2+1] - vertices[p1+1] ):GetNormal()
				ang = normal:Dot( lightPos )
				
				if ( ang < 0 ) then
					lx = 0.8
					ly = 0.8
				else
					ang = 16 - math.floor( ang * 15.9 )
					lx = (ang-1) % 4 + 1
					ly = math.floor( (ang-1) / 4 ) * 0.25 + 0.1
				end
				
				table.Add( triangles, {
					{
						pos = vertices[p3+1] * scale,
						normal = normals[p3+1],
						u = lx,
						v = ly
					},
					{
						pos = vertices[p2+1] * scale,
						normal = normals[p2+1],
						u = lx + 0.1,
						v = ly
					},
					{
						pos = vertices[p1+1] * scale,
						normal = normals[p1+1],
						u = lx + 0.1,
						v = ly + 0.1
					},
				} )
			end
		else
			Error( "SketchUp Parse Error: Less vertices ("..#vertices..") than normals ("..#normals..")! Can't be right!" )
		end
		
		normals = {}
		vertices = {}
	end
	
	return triangles
end

/*
	Draw an exported SketchUp model
*/

if ( model ) then model:Destroy() end
model = NewMesh()
model:BuildFromTriangles( loadSketchUp( file.Read( "sketch/cube.txt" ), Vector( 0.3855, -0.0062, -0.6575 ), 1 ) )

local material = Material( "sketch/shades16_cull" )
hook.Add( "PostDrawOpaqueRenderables", "SUModelDrawing", function()
	render.SetMaterial( material )
	
	local mat = Matrix()
	mat:Translate( Vector( 0, 0, 80 ) )
	
	render.SuppressEngineLighting( true )
		cam.PushModelMatrix( mat )
			model:Draw()
		cam.PopModelMatrix()
	render.SuppressEngineLighting( false )
end )