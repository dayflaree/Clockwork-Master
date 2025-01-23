local capture = false

hook.Add( "PostDrawOpaqueRenderables", "CaptureHook", function()
	if ( capture ) then
		render.CapturePixels()
		print( render.ReadPixel( 1, 1 ) )
		
		capture = false
	end
end )

concommand.Add( "capture", function( ply, _, args )
	capture = true
end )