
NewConCommand( "rp_passout", 5, function( ply )

	ply:Passout();	

end );

NewConCommand( "rp_getup", 5, function( ply )

	ply:Getup();	

end );

NewConCommand( "rp_toollog", 1, function( ply, cmd, arg )
	
	if( !arg[1] ) then arg[1] = math.huge end
	
	arg[1] = math.Clamp( tonumber( arg[1] ), 1, #GAMEMODE.ToolLogs );
	
	local start = #GAMEMODE.ToolLogs - arg[1];
	
	for i = start + 1, #GAMEMODE.ToolLogs do
		
		if( GAMEMODE.ToolLogs[i] ) then
			
			ply:PrintMessage( 2, GAMEMODE.ToolLogs[i] .. "\n" );
			
		end
		
	end
	
end );

NewConCommand( "rp_proplog", 1, function( ply, cmd, arg )
	
	if( !arg[1] ) then arg[1] = math.huge end
	
	arg[1] = math.Clamp( tonumber( arg[1] ), 1, #GAMEMODE.PropLogs );
	
	local start = #GAMEMODE.PropLogs - arg[1];
	
	for i = start + 1, #GAMEMODE.PropLogs do
		
		if( GAMEMODE.PropLogs[i] ) then
			
			ply:PrintMessage( 2, GAMEMODE.PropLogs[i] .. "\n" );
			
		end
		
	end
	
end );

NewConCommand( "rp_a_infroar", 1, function( ply )

	if( ply:GetPlayerIsInfected() ) then
		
		if( ply:ModelStr( "bloodsucker" ) or
			ply:ModelStr( "snork" ) ) then
			
			ply:DoAnimationEvent( ACT_IDLE_ANGRY );
			
			umsg.Start( "DoAnimEventCl" );
				umsg.Entity( ply );
				umsg.Short( ACT_IDLE_ANGRY );
			umsg.End();
			
		end
		
	end


end );

NewConCommand( "rp_a_infplaydead", 1, function( ply )

	if( ply:GetPlayerIsInfected() ) then
		
		if( ply:ModelStr( "bloodsucker" ) or
			ply:ModelStr( "snork" ) ) then
			
			ForceSequence( ply, "slump_idle_" .. table.Random( { "a", "b" } ), -1 );
			
		end
		
	end


end );

for _, s in pairs( InfSoundTypes ) do
	
	NewConCommand( "rp_inf" .. string.lower( s ), 1, function( ply )
		
		if( ply:GetPlayerIsInfected() ) then
			
			local soundtype = nil;
			
			for k, v in pairs( InfSoundTranslate ) do
				
				if( ply:ModelStr( k ) ) then
					
					soundtype = v;
					
				end
				
			end
			
			if( soundtype ) then
				
				ply:EmitSound( Sound( table.Random( InfectedSounds[s][soundtype] ) ) );
				
			end
			
		end

	end );
	
end

NewConCommand( "gm_giveswep", 1, function( ply ) end );
NewConCommand( "gm_spawnswep", 1, function( ply ) end );
NewConCommand( "gm_spawnsent", 1, function( ply ) end );
