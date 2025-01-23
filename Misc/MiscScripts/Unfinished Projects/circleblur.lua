hook.Add( "PostDrawOpaqueRenderables", "PostDrawing", function()
	render.ClearStencil()
	render.SetStencilEnable( true )
	
	render.SetViewPort( 0, 0, ScrW(), ScrH() )
	
	cam.Start2D()
	
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
		render.SetStencilReferenceValue( 1 )
		
		surface.SetDrawColor( 0, 0, 0, 1 )
		
		local verts = {}
		local x, y = ScrW() / 2, ScrH() / 2
		local r = 300
		
		for a = 0, math.pi*2, math.pi/36 do
			table.Add( verts, {
				{ x = x, y = y, u = 0, v = 0 },
				{ x = x + math.cos( a ) * r, y = y + math.sin( a ) * r, u = 0, v = 0 },
				{ x = x + math.cos( a + math.pi/36 ) * r, y = y + math.sin( a + math.pi/36 ) * r, u = 0, v = 0 }
			} )
		end
		surface.DrawPoly( verts )
		
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NOTEQUAL )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilReferenceValue( 1 )
	 
		render.SetMaterial( matOutline )
		render.DrawScreenQuad()
		
	cam.End2D()
	
	render.SetStencilEnable( false )
end )