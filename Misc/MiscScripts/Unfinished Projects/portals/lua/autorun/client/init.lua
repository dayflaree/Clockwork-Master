local portals
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
local matDummy = Material( "debug/white" )

// Helper functions
local function getPortalWidth( portal )
	if ( portal.direction.x == 0 ) then
		return portal.dimensions.x
	else
		return portal.dimensions.y
	end
end

local function calculateNewOffset( portal, offset )
	if ( math.abs( portal.direction.y ) > 0 ) then
		offset.x = -offset.x
		offset.y = -offset.y
	end
	
	return offset
end

local function calculateNewAngles( portal, exit, angles )
	if ( ( portal.direction - exit.direction ):Length() < 1 ) then
		angles:RotateAroundAxis( Vector( 0, 0, 1 ), 180 )
	end
	
	return angles
end

// Render the portal views
local drawingPortalView = false
hook.Add( "PostDrawOpaqueRenderables", "BrushPortalRenderHook", function()
	if ( drawingPortalView ) then
		for _, ent in ipairs( ents.GetAll() ) do
			if ( ent:GetModel() ) then
				ent:DrawModel()
			end
		end
	end
	
	if ( !portals ) then return end
	if ( drawingPortalView ) then return end
	
	for _, portal in ipairs( portals ) do
		// Render view from portal
		local oldRT = render.GetRenderTarget()
		render.SetRenderTarget( rt )
			render.Clear( 0, 0, 255, 255 )
			render.ClearDepth()
			render.ClearStencil()
			
			local offset = LocalPlayer():EyePos() - portal.pos
			offset = calculateNewOffset( portals[portal.exit], offset )
			local camPos = portals[portal.exit].pos + offset
			local camAngles = LocalPlayer():EyeAngles()
			camAngles = calculateNewAngles( portal, portals[portal.exit], camAngles )
			
			drawingPortalView = true
				render.RenderView( {
					x = 0,
					y = 0,
					w = ScrW(),
					h = ScrH(),
					origin = camPos,
					angles = camAngles
				} )
			drawingPortalView = false
			render.UpdateScreenEffectTexture()
		render.SetRenderTarget( oldRT )
		
		// Draw view over portal
		render.ClearStencil()
		render.SetStencilEnable( true )
		
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
		render.SetStencilReferenceValue( 1 )
		
		render.SetMaterial( matDummy )
		render.SetColorModulation( 1, 1, 1 )
		mesh.Begin( MATERIAL_QUADS, 1 )
			mesh.QuadEasy( portal.pos, portal.direction, getPortalWidth( portal ), portal.dimensions.z )
		mesh.End()
		
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilReferenceValue( 1 )
		
		matView:SetMaterialTexture( "$basetexture", rt )
		render.SetMaterial( matView )
		render.DrawScreenQuad()
		
		render.SetStencilEnable( false )
	end
end )

// Receive portal info
usermessage.Hook( "BrushPortalInfo", function( um )
	portals = {}
	
	local c = um:ReadChar()
	for i = 1, c do
		portals[i] = {}
		portals[i].pos = um:ReadVector()
		portals[i].mins = um:ReadVector()
		portals[i].maxs = um:ReadVector()
		portals[i].dimensions = portals[i].maxs - portals[i].mins
		portals[i].direction = um:ReadVector()
		portals[i].exit = um:ReadChar()
	end
	
	PrintTable( portals )
end )