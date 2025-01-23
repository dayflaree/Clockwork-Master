/*-------------------------------------------------------------------------------------------------------------------------
	Serverside OBJ code
-------------------------------------------------------------------------------------------------------------------------*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

resource.AddFile( "data/models/tank.txt" )
resource.AddFile( "materials/models/tank.vmt" )

/*-------------------------------------------------------------------------------------------------------------------------
	Spawn function
-------------------------------------------------------------------------------------------------------------------------*/

function ENT:SpawnFunction( ply, tr )
	if ( !tr.HitWorld ) then return false end
	
	local ent = ents.Create( "objmodel" )
	ent:SetPos( tr.HitPos + Vector( 0, 0, 64 ) )
	ent:Spawn()
	
	return ent
end

/*-------------------------------------------------------------------------------------------------------------------------
	Initialization
-------------------------------------------------------------------------------------------------------------------------*/

function ENT:Initialize()
	self:SetModel( "models/props_junk/wood_crate002a.mdl" )
	
	local verts, min, max = loadOBJ( file.Read( "models/tank.txt" ) )
	self:PhysicsInitBox( min, max )
	self:SetCollisionBounds( min, max )
	
	// TODO: Calculate best fitting mins and maxs based on vertex population (perhaps an octree?)
	
	self:GetPhysicsObject():Wake()
end