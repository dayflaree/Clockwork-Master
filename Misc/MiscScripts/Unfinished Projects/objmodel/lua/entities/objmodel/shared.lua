/*-------------------------------------------------------------------------------------------------------------------------
	OBJ entity information
-------------------------------------------------------------------------------------------------------------------------*/

ENT.Type							= "anim"
ENT.Base							= "base_gmodentity"

ENT.PrintName					= "OBJ Model"
ENT.Author						= "Overv"
ENT.Contact						= "overv161@gmail.com"
ENT.Purpose						= "Drool on it."
ENT.Instructions				= "Use with care. Contains volatile amounts of awesome and win."

ENT.Spawnable					= true
ENT.AdminSpawnable		= true

/*-------------------------------------------------------------------------------------------------------------------------
	OBJ parser
-------------------------------------------------------------------------------------------------------------------------*/

local n = tonumber
function loadOBJ( src )
	local vertices, normals, texcoords, faces, min, max = {}, {}, {}, {}, Vector( 9999, 9999, 9999 ), Vector( -9999, -9999, -9999 )
	
	for line in string.gmatch( src, "[^\n]+" ) do
		local id, x, y, z = string.match( line, "(.+)%s(.+)%s(.+)%s(.+)$" )
		
		if ( id == "v " ) then
			table.insert( vertices, Vector( n(x), n(y), n(z) ) )
			if ( n(x) < min.x ) then min.x = n(x) elseif ( n(x) > max.x ) then max.x = n(x) end
			if ( n(y) < min.y ) then min.y = n(y) elseif ( n(y) > max.y ) then max.y = n(y) end
			if ( n(z) < min.z ) then min.z = n(z) elseif ( n(z) > max.z ) then max.z = n(z) end
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
	
	return faces, min, max
end