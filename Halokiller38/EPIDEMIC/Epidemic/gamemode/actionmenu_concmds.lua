
AMConCommand( "rp_am_useent", function( ply, cmd, arg )

	ply:UseItemEntity( ply:GetTable().ActionMenu.Entity );

end );

AMConCommand( "rp_am_carryweap", function( ply, cmd, arg )

	ply:CarryWeapon( ply:GetTable().ActionMenu.Entity );

end );


AMConCommand( "rp_am_entitytoinv", function( ply, cmd, arg )

	local id = arg[1];
	local ent = ply:GetTable().ActionMenu.Entity;
	
	ply:HandlePickingUpEntity( id, ent );
	
end );

AMConCommand( "rp_am_examineent", function( ply, cmd, arg )
	
	ply:GetTable().ActionMenu.Entity:GetTable().ItemData.Owner = ply;
	ply:GetTable().ActionMenu.Entity:GetTable().ItemData.Examine( ply:GetTable().ActionMenu.Entity:GetTable().ItemData );	

end );