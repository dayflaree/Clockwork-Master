concommand.Add( "dupethis", function( ply, _, args )
	local toolgun = ply:GetWeapon( "gmod_tool" )
	local ent = args[1] and Entity( tonumber( args[1] ) ) or ply:GetEyeTrace().Entity
	
	if ( toolgun and toolgun:IsValid() and ent and ent:IsValid() ) then
		toolgun.Tool.adv_duplicator:RightClick( { Entity = ent, HitPos = ent:GetPos() } )
	end
end )