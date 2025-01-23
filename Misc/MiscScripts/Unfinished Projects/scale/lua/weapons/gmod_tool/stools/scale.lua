TOOL.Category		= "Construction"
TOOL.Name			= "#Scale"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "x" ] = 1
TOOL.ClientConVar[ "y" ] = 1
TOOL.ClientConVar[ "z" ] = 1

if ( CLIENT ) then
    language.Add( "Tool_scale_name", "Scale" )
    language.Add( "Tool_scale_desc", "Scale props to make them bigger or smaller!" )
    language.Add( "Tool_scale_0", "Click to scale a prop." )
end

function TOOL:PhysScale( ent, scale )
	if ( !_R.PhysObj.GetConvexMesh ) then require( "queryphys" ) end
	
	local phys = ent:GetPhysicsObject()
	local convexCount = phys:GetConvexCount()

	local meshes = {}

	for convex = 0, convexCount - 1 do
		local mesh = phys:GetConvexMesh(convex)
		local offset = nil
		for _, tri in pairs(mesh) do
			local original = tri
			tri[1] = tri[1] * scale.x
			tri[2] = tri[2] * scale.y
			tri[3] = tri[3] * scale.z
			if(not offset) then
				offset = {}
				offset[1] = tri[1] - original[1]
				offset[2] = tri[2] - original[2]
				offset[3] = tri[3] - original[3]
			else
				tri[1] = tri[1] - offset[1]
				tri[2] = tri[2] - offset[2]
				tri[3] = tri[3] - offset[3]
			end
		end
				
		
		table.insert( meshes, mesh )
	end

	phys:RebuildFromConvexs( ent:GetPos(), ent:GetAngles(), phys:GetMass() * scale.x^3, phys:GetDamping(), phys:GetRotDamping(), 0.9, 0.3, meshes )
end

function TOOL:LeftClick( trace )
	local ent = trace.Entity
	local x, y, z = math.Clamp( self:GetClientNumber( "x" ), 0.1, 10 ), math.Clamp( self:GetClientNumber( "y" ), 0.1, 10 ), math.Clamp( self:GetClientNumber( "z" ), 0.1, 10 )
	
    if ( !ent or !ent:IsValid() or ent:GetClass() != "prop_physics" ) then return false end
	if ( CLIENT ) then return true end
	
	ent:SetDTVector( 0, Vector( x, y, z ) )
	self:PhysScale( ent, Vector( x, y, z ) )
end

function TOOL:RightClick( trace )
	return self:LeftClick( trace )
end

function TOOL.BuildCPanel( panel )
	panel:AddControl( "Slider", { Label = "X",
                    Type = "Float",
                    Min = 0.01,
                    Max	= 10,
					Value = 1.0,
                    Command = "scale_x",
                    Description = "X"} )
					
	panel:AddControl( "Slider", { Label = "Y",
                    Type = "Float",
                    Min = 0.01,
                    Max	= 10,
					Value = 1.0,
                    Command = "scale_y",
                    Description = "y"} )
					
	panel:AddControl( "Slider", { Label = "Z",
                    Type = "Float",
                    Min = 0.01,
                    Max	= 10,
					Value = 1.0,
                    Command = "scale_z",
                    Description = "Z"} )
end

hook.Add( "PreDrawOpaqueRenderables", "ScaleUpdate", function()
	for _, ent in ipairs( ents.GetAll() ) do
		local scale = ent:GetDTVector( 0 )
		if ( scale:Length() > 0 and ( !ent.Scale or scale.x != ent.Scale.x or scale.y != ent.Scale.y or scale.z != ent.Scale.z ) ) then
			ent:SetModelScale( scale )
			ent.Scale = scale
		end
	end
end )