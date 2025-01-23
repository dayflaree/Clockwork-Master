local drawOutline

hook.Add( "PostDrawOpaqueRenderables", "LOL", function()
	local ent  = LocalPlayer():GetEyeTrace().Entity
	if ( ent and ent:IsValid() ) then
		cam.IgnoreZ( true )
			ent:DrawShadow( false )
			ent:DrawModel()
		cam.IgnoreZ( false )
	end
end )