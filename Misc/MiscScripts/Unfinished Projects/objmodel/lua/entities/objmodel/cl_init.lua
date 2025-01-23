/*-------------------------------------------------------------------------------------------------------------------------
	Clientside OBJ code
-------------------------------------------------------------------------------------------------------------------------*/

include( "shared.lua" )

/*-------------------------------------------------------------------------------------------------------------------------
	Initialization
-------------------------------------------------------------------------------------------------------------------------*/

function ENT:Initialize()
	local verts, min, max = loadOBJ( file.Read( "models/tank.txt" ) )
	
	self.OBJModel = NewMesh()
	self.OBJModel:BuildFromTriangles( verts )
	self.OBJMaterial = Material( "models/tank" )
	
	self:PhysicsInitSphere( min, max )
	self:SetCollisionBounds( min, max )
	
	self:DrawShadow( false )
end

/*-------------------------------------------------------------------------------------------------------------------------
	Drawing
-------------------------------------------------------------------------------------------------------------------------*/

function ENT:Draw()	
	render.SetMaterial( self.OBJMaterial )
	
	local mat = Matrix()
	mat:Translate( self:GetPos() )
	mat:Rotate( self:GetAngles() )
	
	cam.PushModelMatrix( mat )
		self.OBJModel:Draw()
	cam.PopModelMatrix()
end