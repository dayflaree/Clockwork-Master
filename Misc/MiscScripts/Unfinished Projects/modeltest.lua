/*
	Load an OBJ model
*/

local n = tonumber
local function loadOBJ( path )
	local vertices, normals, texcoords, faces = {}, {}, {}, {}
	
	local src = file.Read( path )
	for line in string.gmatch( src, "[^\n]+" ) do
		local id, x, y, z = string.match( line, "(.+)%s(.+)%s(.+)%s(.+)$" )
		
		if ( id == "v " ) then
			table.insert( vertices, Vector( n(x), n(y), n(z) ) )
		elseif ( id == "vn" ) then
			table.insert( normals, Vector( n(x), n(y), n(z) ) )
		elseif ( id == "vt" ) then
			table.insert( texcoords, { u = n(x), v = 1 - n(y) } )
		elseif ( id == "f" ) then
			for _, face in ipairs{ z, y, x } do
				local vertex, texcoord, normal = string.match( face, "(.+)\/(.+)\/(.+)" )
				
				table.insert( faces, {
					pos = vertices[n(vertex)],
					normal = normals[n(normal)],
					u = texcoords[n(texcoord)].u,
					v = texcoords[n(texcoord)].v
				} )
			end
		end
	end
	
	return faces
end

/*
	Draw an OBJ model
*/

if ( model ) then model:Destroy() end
model = NewMesh()
model:BuildFromTriangles( loadOBJ( "models/facepunch.txt" ) )

local material = Material( "models/debug/debugwhite" )

hook.Add( "PostDrawOpaqueRenderables", "OBJModelDrawing", function()
	render.SetMaterial( material )
	
	local mat = Matrix()
	mat:Translate( Vector( 0, 0, -300 ) )
	
	cam.PushModelMatrix( mat )
		model:Draw()
	cam.PopModelMatrix()
end )