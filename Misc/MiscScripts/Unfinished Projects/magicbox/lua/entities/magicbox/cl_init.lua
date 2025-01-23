/*-------------------------------------------------------------------------------------------------------------------------
	Clientside magic box code
-------------------------------------------------------------------------------------------------------------------------*/

include( "shared.lua" )

/*-------------------------------------------------------------------------------------------------------------------------
	Initialization
-------------------------------------------------------------------------------------------------------------------------*/

function ENT:Initialize()
	self:SetModelScale( Vector( 1, 1, 1 ) * 1.2 )
end

/*-------------------------------------------------------------------------------------------------------------------------
	Drawing
-------------------------------------------------------------------------------------------------------------------------*/

local rt = render.GetScreenEffectTexture()
local matView = CreateMaterial(
	"UnlitGeneric",
	"GMODScreenspace",
	{
		["$basetexture"] = rt,
		["$basetexturetransform"] = "center .5 .5 scale -1 -1 rotate 0 translate 0 0",
		["$texturealpha"] = "0",
		["$vertexalpha"] = "1",
	}
)

function ENT:Draw()
	self:DrawModel()
	
	//
	//	Render view in box world
	//
	
	local oldRT = render.GetRenderTarget()
	render.SetRenderTarget( rt )
	
	render.Clear( 0, 0, 0, 255 )
	render.ClearDepth()
	render.ClearStencil()
	
	local viewCenter = self:GetPos() + Vector( -0.2, -23.2, 0 )
	local worldCenter = self:GetNWVector( "WorldPos" ) + Vector( 160, -32, 76 )
	local offset = viewCenter - LocalPlayer():EyePos() + Vector( 0, 0, 20 )
	local camPos = worldCenter - offset + Vector( 0, 0, 5 )
	
	// Hide crates that can block the camera
	for _, ent in pairs( ents.GetAll() ) do
		if ( ent:GetOwner() == self and ent:GetPos().y < self:GetNWVector( "WorldPos" ).y ) then
			ent:SetNoDraw( true )
		end
	end
	
	render.RenderView( {
		x = 0,
		y = 0,
		w = ScrW(),
		h = ScrH(),
		origin = camPos,
		angles = LocalPlayer():EyeAngles()
	}	)
	render.UpdateScreenEffectTexture()
	
	// Hide crates if we aren't in the magic box world area (to prevent people from spotting them in the air)
	for _, ent in pairs( ents.GetAll() ) do
		if ( ent:GetOwner() == self ) then
			ent:SetNoDraw( false )
		end
	end
	
	render.SetRenderTarget( oldRT )
	
	//
	//	Draw view over box
	//
	
	render.ClearStencil()
	render.SetStencilEnable( true )
	
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilReferenceValue( 1 )
	
	mesh.Begin( MATERIAL_QUADS, 1 )
		mesh.QuadEasy( self:GetPos() + Vector( -0.2, -23.2, 0 ), Vector( 0, -1, 0 ), 40.5, 72 )
	mesh.End()
	
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilReferenceValue( 1 )
	
	matView:SetMaterialTexture( "$basetexture", rt )
	render.SetMaterial( matView )
	render.DrawScreenQuad()
	
	render.SetStencilEnable( false )
end